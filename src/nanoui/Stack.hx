package nanoui;

class Stack<T> {
	final data:Array<T> = new Array<T>();

	public var count(default, null):Int = 0;

	public function push(item:T) {
		data[count++] = item;
	}

	public function pop():T {
		return data[--count];
	}

	public function get():T {
		return data[count - 1];
	}

	public function getAt(index:Int):T {
		return data[index];
	}

	public function clear() {
		count = 0;
	}

	public function sort(f:T->T->Int) {
		data.resize(count);
		data.sort(f);
	}
}
