package nanoui;

class Defs {
	public static inline final COMMANDLIST_SIZE = (256 * 1024);
	public static inline final ROOTLIST_SIZE = 32;
	public static inline final CONTAINERSTACK_SIZE = 32;
	public static inline final CLIPSTACK_SIZE = 32;
	public static inline final IDSTACK_SIZE = 32;
	public static inline final LAYOUTSTACK_SIZE = 16;
	public static inline final CONTAINERPOOL_SIZE = 48;
	public static inline final TREENODEPOOL_SIZE = 48;
	public static inline final MAX_WIDTHS = 16;
	public static inline final REAL_FMT = "%.3g";
	public static inline final SLIDER_FMT = "%.2f";
	public static inline final MAX_FMT = 127;
}

typedef REAL = Float;
typedef Real = REAL;
typedef Id = Int;
typedef Font = Dynamic;

enum abstract MUColor(Int) from Int to Int {
	final TEXT;
	final BORDER;
	final WINDOWBG;
	final TITLEBG;
	final TITLETEXT;
	final PANELBG;
	final BUTTON;
	final BUTTONHOVER;
	final BUTTONFOCUS;
	final BASE;
	final BASEHOVER;
	final BASEFOCUS;
	final SCROLLBASE;
	final SCROLLTHUMB;
	final MAX;
}

enum abstract MUIcon(Int) from Int to Int {
	final CLOSE = 1; // @check why de fuk dis 1??
	final CHECK;
	final COLLAPSED;
	final EXPANDED;
	final MAX;
}

enum abstract MUResult(Int) from Int to Int {
	final ACTIVE = (1 << 0);
	final SUBMIT = (1 << 1);
	final CHANGE = (1 << 2);
}

enum abstract MUOption(Int) from Int to Int {
	final NONE = (0);
	final ALIGNCENTER = (1 << 0);
	final ALIGNRIGHT = (1 << 1);
	final NOINTERACT = (1 << 2);
	final NOFRAME = (1 << 3);
	final NORESIZE = (1 << 4);
	final NOSCROLL = (1 << 5);
	final NOCLOSE = (1 << 6);
	final NOTITLE = (1 << 7);
	final HOLDFOCUS = (1 << 8);
	final AUTOSIZE = (1 << 9);
	final POPUP = (1 << 10);
	final CLOSED = (1 << 11);
	final EXPANDED = (1 << 12);
}

enum abstract MUMouseButton(Int) from Int to Int {
	final LEFT = (1 << 0);
	final RIGHT = (1 << 1);
	final MIDDLE = (1 << 2);
}

enum abstract MUKey(Int) from Int to Int {
	final SHIFT = (1 << 0);
	final CTRL = (1 << 1);
	final ALT = (1 << 2);
	final BACKSPACE = (1 << 3);
	final RETURN = (1 << 4);
}
