package hacksaw.profiler;

import haxe.Json;
import haxe.macro.Context;
import haxe.macro.Expr;
import thx.Assert;

using thx.Arrays;

#if js
import js.Browser;
import js.html.AnchorElement;
import js.html.Blob;
import js.html.URL;
#else
import haxe.Timer;
import sys.io.File;
#end

class Mark {
	public var name:String;
	public var parent:Null<Mark>;
	public var children:std.Array<Mark>;

	public var timestampBegin:Float;
	public var timestampEnd:Float;

	public function new(name:String, timestampBegin:Float, parent:Null<Mark> = null) {
		this.name = name;
		this.parent = parent;
		this.children = new std.Array<Mark>();

		this.timestampBegin = timestampBegin;
		this.timestampEnd = 0.0;

		if (parent != null)
			parent.children.push(this);
	}
}

@:structInit
class TraceEvent {
	public var name:String;
	public var cat:String;
	public var ph:String;
	public var pid:Int;
	public var tid:Int;
	public var ts:Int;
}

class Profiler {
	static var _markStack:std.Array<Mark> = new std.Array<Mark>();
	static var _markRecord:std.Array<Mark> = new std.Array<Mark>();

	public static function profileBlockStart(name:String) {
		_markStack.push(new Mark(name, timestamp(), (_markStack.length != 0) ? _markStack[_markStack.length - 1] : null));
	}

	public static function profileBlockEnd() {
		Assert.isFalse(_markStack.length <= 0, "There is no mark to pop. The number of profileBlockStart and profileBlockEnd do not match.");

		var mark:Mark = _markStack.pop();
		mark.timestampEnd = timestamp();

		if (mark.parent == null) {
			_markRecord.push(mark);
		}
	}

	macro public static function profileBlock(name:String, expr:Expr):Expr {
		var body = switch (expr.expr) {
			case EBlock(_):
				expr;
			case _:
				macro {$expr;}
		}

		return macro {
			Profiler.profileBlockStart($v{name});
			try {
				$body;
			} catch (e:Dynamic) {
				Profiler.profileBlockEnd();
				throw e;
			}
			Profiler.profileBlockEnd();
		}
	}

	inline public static function timestamp():Float {
		#if js
		return Browser.window.performance.now();
		#else
		return Timer.stamp() * 1000.0 * 1000.0;
		#end
	}

	public static function printMark(mark:Mark, depth:Int = 0) {
		final indent = StringTools.lpad("", "-", depth);
		trace(indent + "Mark: " + mark.name + ", Begin: " + mark.timestampBegin + ", End: " + mark.timestampEnd);
		for (child in mark.children) {
			printMark(child, depth + 1);
		}
	}

	public static function printMarks() {
		for (mark in _markRecord) {
			printMark(mark);
		}
	}

	static final pid = 0;
	static final tid = 0;
	static final cat = "PERF";

	public static function dumpMark(mark:Mark, traceEvents:Array<TraceEvent>) {
		traceEvents.push({
			name: mark.name,
			cat: cat,
			ph: "B",
			pid: pid,
			tid: tid,
			ts: Std.int(mark.timestampBegin)
		});

		for (child in mark.children) {
			dumpMark(child, traceEvents);
		}

		traceEvents.push({
			name: mark.name,
			cat: cat,
			ph: "E",
			pid: pid,
			tid: tid,
			ts: Std.int(mark.timestampEnd)
		});
	}

	public static function dumpToObject():Dynamic {
		var traceEvents = new Array<TraceEvent>();

		for (mark in _markRecord) {
			dumpMark(mark, traceEvents);
		}

		return {
			traceEvents: traceEvents,
			displayTimeUnit: "ms"
		};
	}

	public static function dumpToJson():String {
		return Json.stringify(dumpToObject());
	}

	public static function dumpToJsonFile(filename:String) {
		var jsonString = dumpToJson();
		trace(jsonString);
		#if js
		var blob = new Blob([jsonString], {type: "application/json"});
		var url = URL.createObjectURL(blob);
		var link:AnchorElement = cast Browser.document.createAnchorElement();
		link.href = url;
		link.download = filename;
		Browser.document.body.appendChild(link);
		link.click();
		Browser.document.body.removeChild(link);
		URL.revokeObjectURL(url);
		#else
		File.saveContent(filename, jsonString);
		#end
		trace("Profiler data saved.");
	}

	macro public static function injectProfiler():Array<Field> {
		var pos = Context.currentPos();
		var fields = Context.getBuildFields();
		var localClass = Context.getLocalClass();
		if (localClass == null)
			return fields;

		fields.filter((field:Field) -> field.meta != null && field.meta.find(m -> m.name == ":profile") != null).each((field:Field) -> {
			switch (field.kind) {
				case FFun(func):
					trace(field.name);
					func.expr = macro {
						Profiler.profileBlockStart($v{localClass.get().name} + ":" + $v{field.name});
						try {
							${func.expr};
						} catch (e:Dynamic) {
							Profiler.profileBlockEnd();
							throw e;
						}
						Profiler.profileBlockEnd();
					}
					field.kind = FFun(func);
				default:
					Context.error("Cannot mark non-function field as :profile!", Context.currentPos());
			}
		});

		return fields;
	}
}
