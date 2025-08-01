package nanoui;

import nanoui.Defs;
import nanoui.Stack;
import thx.Assert;

@:structInit
class Vec2 {
	public var x:Int;
	public var y:Int;
}

@:structInit class Rect {
	public var x:Int;
	public var y:Int;
	public var w:Int;
	public var h:Int;
}

@:structInit class Color {
	public var r:Int;
	public var g:Int;
	public var b:Int;
	public var a:Int;
}

@:structInit
class PoolItem {
	public var id:Defs.Id;
	public var last_update:Int;
}

@:structInit
class BaseCommand {
	public var type:Int;
	public var size:Int;
}

@:structInit
class JumpCommand {
	public var base:BaseCommand;
	public var dst:Dynamic;
}

@:structInit
class ClipCommand {
	public var base:BaseCommand;
	public var rect:Rect;
}

@:structInit
class RectCommand {
	public var base:BaseCommand;
	public var rect:Rect;
	public var color:Color;
}

@:structInit
class TextCommand {
	public var base:BaseCommand;
	public var font:Font;
	public var pos:Vec2;
	public var color:Color;
	public var str:String;
}

@:structInit
class IconCommand {
	public var base:BaseCommand;
	public var rect:Rect;
	public var id:Int;
	public var color:Color;
}

enum Command {
	Jump(cmd:JumpCommand);
	Clip(cmd:ClipCommand);
	Rect(cmd:RectCommand);
	Text(cmd:TextCommand);
	Icon(cmd:IconCommand);
}

@:structInit
class Layout {
	public var body:Rect;
	public var next:Rect;
	public var position:Vec2;
	public var size:Vec2;
	public var max:Vec2;
	public var widths:Array<Int>;
	public var items:Int;
	public var item_index:Int;
	public var next_row:Int;
	public var next_type:Int;
	public var indent:Int;
}

@:structInit
class Container {
	public var head:Command;
	public var tail:Command;
	public var rect:Rect;
	public var body:Rect;
	public var content_size:Vec2;
	public var scroll:Vec2;
	public var zindex:Int;
	public var open:Int;
}

@:structInit
class Style {
	public var font:Font;
	public var size:Vec2;
	public var padding:Int;
	public var spacing:Int;
	public var indent:Int;
	public var title_height:Int;
	public var scrollbar_size:Int;
	public var thumb_size:Int;
	public var colors:Array<Color>;
}

function vec2(x:Int, y:Int):Vec2 {
	return {x: x, y: y};
}

function rect(x:Int, y:Int, w:Int, h:Int):Rect {
	return {
		x: x,
		y: y,
		w: w,
		h: h
	};
}

function color(r:Int, g:Int, b:Int, a:Int):Color {
	return {
		r: r,
		g: g,
		b: b,
		a: a
	};
}

class Context {
	/* callbacks */
	public var text_width:(font:Font, str:String, len:Int) -> Int;
	public var text_height:(font:Font) -> Int;
	public var draw_frame:(ctx:Context, rect:Rect, colorid:Int) -> Void;

	/* core state */
	var style:Style;
	var hover:Defs.Id;
	var focus:Defs.Id;
	var last_id:Defs.Id;
	var last_rect:Rect;
	var last_zindex:Int;
	var updated_focus:Int;
	var frame:Int;
	var hover_root:Container;
	var next_hover_root:Container;
	var scroll_target:Container;
	var number_edit_buf:String;
	var number_edit:Defs.Id;
	/* stacks */
	var command_list:Stack<Int>;
	var root_list:Stack<Container>;
	var container_stack:Stack<Container>;
	var clip_stack:Stack<Rect>;
	var id_stack:Stack<Id>;
	var layout_stack:Stack<Layout>;
	/* retained state pools */
	var container_pool:Array<PoolItem>;
	var containers:Array<Container>;
	var treenode_pool:Array<PoolItem>;
	/* input state */
	var mouse_pos:Vec2;
	var last_mouse_pos:Vec2;
	var mouse_delta:Vec2;
	var scroll_delta:Vec2;
	var mouse_down:Int;
	var mouse_pressed:Int;
	var key_down:Int;
	var key_pressed:Int;
	var input_text:String;

	static function draw_frame_default(ctx:Context, rect:Rect, colorid:Int):Void {
		#if 0
		ctx.draw_rect(rect, ctx -> style -> colors[colorid]);
		if (colorid == MU_COLOR_SCROLLBASE || colorid == MU_COLOR_SCROLLTHUMB || colorid == MU_COLOR_TITLEBG) {
			return;
		}
		/* draw border */
		if (ctx -> style -> colors[MU_COLOR_BORDER].a) {
			mu_draw_box(ctx, expand_rect(rect, 1), ctx -> style -> colors[MU_COLOR_BORDER]);
		}
		#end
	}

	static var default_style:Style = {
		font: null,
		size: {x: 68, y: 10},
		padding: 5,
		spacing: 4,
		indent: 24,
		title_height: 24,
		scrollbar_size: 12,
		thumb_size: 8,
		colors: [
			{
				r: 230,
				g: 230,
				b: 230,
				a: 255
			}, /* MUColor.TEXT */
			{
				r: 25,
				g: 25,
				b: 25,
				a: 255
			}, /* MUColor.BORDER */
			{
				r: 50,
				g: 50,
				b: 50,
				a: 255
			}, /* MUColor.WINDOWBG */
			{
				r: 25,
				g: 25,
				b: 25,
				a: 255
			}, /* MUColor.TITLEBG */
			{
				r: 240,
				g: 240,
				b: 240,
				a: 255
			}, /* MUColor.TITLETEXT */
			{
				r: 0,
				g: 0,
				b: 0,
				a: 0
			}, /* MUColor.PANELBG */
			{
				r: 75,
				g: 75,
				b: 75,
				a: 255
			}, /* MUColor.BUTTON */
			{
				r: 95,
				g: 95,
				b: 95,
				a: 255
			}, /* MUColor.BUTTONHOVER */
			{
				r: 115,
				g: 115,
				b: 115,
				a: 255
			}, /* MUColor.BUTTONFOCUS */
			{
				r: 30,
				g: 30,
				b: 30,
				a: 255
			}, /* MUColor.BASE */
			{
				r: 35,
				g: 35,
				b: 35,
				a: 255
			}, /* MUColor.BASEHOVER */
			{
				r: 40,
				g: 40,
				b: 40,
				a: 255
			}, /* MUColor.BASEFOCUS */
			{
				r: 43,
				g: 43,
				b: 43,
				a: 255
			}, /* MUColor.SCROLLBASE */
			{
				r: 30,
				g: 30,
				b: 30,
				a: 255
			} /* MUColor.SCROLLTHUMB */
		]
	}

	public function init():Void {
		style = default_style;
	}

	public function begin():Void {
		Assert.notNull(text_width);
		Assert.notNull(text_height);

		command_list.clear();
		root_list.clear();
		scroll_target = null;
		hover_root = next_hover_root;
		next_hover_root = null;
		mouse_delta.x = mouse_pos.x - last_mouse_pos.x;
		mouse_delta.y = mouse_pos.y - last_mouse_pos.y;
		frame++;
	}

	public function end():Void {
		Assert.equals(container_stack.count, 0);
		Assert.equals(clip_stack.count, 0);
		Assert.equals(id_stack.count, 0);
		Assert.equals(layout_stack.count, 0);

		/* handle scroll input */
		if (scroll_target != null) {
			scroll_target.scroll.x += scroll_delta.x;
			scroll_target.scroll.y += scroll_delta.y;
		}
		/* unset focus if focus id was not touched this frame */
		if (updated_focus == 0) {
			focus = 0;
		}
		updated_focus = 0;

		/* bring hover root to front if mouse was pressed */
		if (mouse_pressed != 0 && next_hover_root != null && next_hover_root.zindex < last_zindex && next_hover_root.zindex >= 0) {
			bring_to_front(next_hover_root);
		}
		/* reset input state */
		key_pressed = 0;
		input_text = "";
		mouse_pressed = 0;
		scroll_delta = vec2(0, 0);
		last_mouse_pos = mouse_pos;
		/* sort root containers by zindex */
		var n = root_list.count;
		// root_list.sort((index) ->); //
		// ;
		/* set root container jump commands */
		// ;
		/* if this is the first container then make the first command jump to it.
		** otherwise set the previous container's tail to jump to this one */
		/* make the last container's tail jump to the end of command list */
	}

	public function set_focus(id:Defs.Id):Void {}

	public function get_id(data:Dynamic, size:Int):Defs.Id {
		return null;
	}

	public function push_id(data:Dynamic, size:Int):Void {}

	public function pop_id():Void {}

	public function push_clip_rect(rect:Rect):Void {}

	public function pop_clip_rect():Void {}

	public function get_clip_rect():Rect {
		return null;
	}

	public function check_clip(r:Rect):Int {
		return null;
	}

	public function get_current_container():Container {
		return null;
	}

	public function get_container(name:String):Container {
		return null;
	}

	public function bring_to_front(cnt:Container):Void {}

	public function pool_init(items:PoolItem, len:Int, id:Defs.Id):Int {
		return null;
	}

	public function pool_get(items:PoolItem, len:Int, id:Defs.Id):Int {
		return null;
	}

	public function pool_update(items:PoolItem, idx:Int):Void {}

	public function input_mousemove(x:Int, y:Int):Void {}

	public function input_mousedown(x:Int, y:Int, btn:Int):Void {}

	public function input_mouseup(x:Int, y:Int, btn:Int):Void {}

	public function input_scroll(x:Int, y:Int):Void {}

	public function input_keydown(key:Int):Void {}

	public function input_keyup(key:Int):Void {}

	public function input_text_func(text:String):Void {}

	public function push_command(type:Int, size:Int):Command {
		return null;
	}

	public function next_command(cmd:Command):Int {
		return null;
	}

	public function set_clip(rect:Rect):Void {}

	public function draw_rect(rect:Rect, color:Color):Void {}

	public function draw_box(rect:Rect, color:Color):Void {}

	public function draw_text(font:Font, str:String, len:Int, pos:Vec2, color:Color):Void {}

	public function draw_icon(id:Int, rect:Rect, color:Color):Void {}

	public function layout_row(items:Int, widths:Int, height:Int):Void {}

	public function layout_width(width:Int):Void {}

	public function layout_height(height:Int):Void {}

	public function layout_begin_column():Void {}

	public function layout_end_column():Void {}

	public function layout_set_next(r:Rect, relative:Int):Void {}

	public function layout_next():Rect {
		return null;
	}

	public function draw_control_frame(id:Defs.Id, rect:Rect, colorid:Int, opt:MUOption):Void {}

	public function draw_control_text(str:String, rect:Rect, colorid:Int, opt:MUOption):Void {}

	public function mouse_over(rect:Rect):Int {
		return null;
	}

	public function update_control(id:Defs.Id, rect:Rect, opt:MUOption):Void {}

	public function text(text:String):Void {}

	public function label(text:String):Void {}

	public function button(label:String, icon:Int = 0, opt:MUOption = MUOption.ALIGNCENTER):Int {
		return null;
	}

	public function checkbox(label:String, state:Int):Int {
		return null;
	}

	public function textbox_raw(buf:String, bufsz:Int, id:Defs.Id, r:Rect, opt:MUOption):Int {
		return null;
	} // TODO buf is probably not a string

	public function textbox(buf:String, bufsz:Int, opt:MUOption = MUOption.NONE):Int {
		return null;
	} // TODO buf is probably not a string

	public function slider(value:Real, low:Real, high:Real, step:Real = 0, fmt:String = Defs.SLIDER_FMT, opt:MUOption = MUOption.ALIGNCENTER):Int {
		return null;
	}

	public function number(value:Real, step:Real, fmt:String = Defs.SLIDER_FMT, opt:MUOption = MUOption.ALIGNCENTER):Int {
		return null;
	}

	public function header(label:String, opt:MUOption = MUOption.NONE):Int {
		return null;
	}

	public function begin_treenode(label:String, opt:MUOption = MUOption.NONE):Int {
		return null;
	}

	public function end_treenode():Void {}

	public function begin_window(title:String, rect:Rect, opt:MUOption = MUOption.NONE):Int {
		return null;
	}

	public function end_window():Void {}

	public function open_popup(name:String):Void {}

	public function begin_popup(name:String):Int {
		return null;
	}

	public function end_popup():Void {}

	public function begin_panel(name:String, opt:MUOption = MUOption.NONE):Void {}

	public function end_panel():Void {}
}
