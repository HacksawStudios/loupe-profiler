package;

class mu_Vec2 {
	var x:Int;
	var y:Int;
}
class mu_Vec2 {
	var x:Int;
	var y:Int;
	var w:Int;
	var h:Int;
}

class Context {
	public function mu_vec2(x: Int, y: Int): mu_Vec2;
	public function mu_rect(x: Int, y: Int, w: Int, h: Int): mu_Rect;
	public function mu_color(r: Int, g: Int, b: Int, a: Int): mu_Color;

	public function mu_init(ctx: mu_Context): Void;
	public function mu_begin(ctx: mu_Context): Void;
	public function mu_end(ctx: mu_Context): Void;
	public function mu_set_focus(ctx: mu_Context, id: mu_Id): Void;
	public function mu_get_id(ctx: mu_Context, data: Dynamic, size: Int): mu_Id;
	public function mu_push_id(ctx: mu_Context, data: Dynamic, size: Int): Void;
	public function mu_pop_id(ctx: mu_Context): Void;
	public function mu_push_clip_rect(ctx: mu_Context, rect: mu_Rect): Void;
	public function mu_pop_clip_rect(ctx: mu_Context): Void;
	public function mu_get_clip_rect(ctx: mu_Context): mu_Rect;
	public function mu_check_clip(ctx: mu_Context, r: mu_Rect): Int;
	public function mu_get_current_container(ctx: mu_Context): mu_Container;
	public function mu_get_container(ctx: mu_Context, name: String): mu_Container;
	public function mu_bring_to_front(ctx: mu_Context, cnt: mu_Container): Void;

	public function mu_pool_init(ctx: mu_Context, items: mu_PoolItem, len: Int, id: mu_Id): Int;
	public function mu_pool_get(ctx: mu_Context, items: mu_PoolItem, len: Int, id: mu_Id): Int;
	public function mu_pool_update(ctx: mu_Context, items: mu_PoolItem, idx: Int): Void;

	public function mu_input_mousemove(ctx: mu_Context, x: Int, y: Int): Void;
	public function mu_input_mousedown(ctx: mu_Context, x: Int, y: Int, btn: Int): Void;
	public function mu_input_mouseup(ctx: mu_Context, x: Int, y: Int, btn: Int): Void;
	public function mu_input_scroll(ctx: mu_Context, x: Int, y: Int): Void;
	public function mu_input_keydown(ctx: mu_Context, key: Int): Void;
	public function mu_input_keyup(ctx: mu_Context, key: Int): Void;
	public function mu_input_text(ctx: mu_Context, text: String): Void;

	public function mu_push_command(ctx: mu_Context, type: Int, size: Int): mu_Command;
	public function mu_next_command(ctx: mu_Context, cmd: mu_Command): Int;
	public function mu_set_clip(ctx: mu_Context, rect: mu_Rect): Void;
	public function mu_draw_rect(ctx: mu_Context, rect: mu_Rect, color: mu_Color): Void;
	public function mu_draw_box(ctx: mu_Context, rect: mu_Rect, color: mu_Color): Void;
	public function mu_draw_text(ctx: mu_Context, font: mu_Font, str: String, len: Int, pos: mu_Vec2, color: mu_Color): Void;
	public function mu_draw_icon(ctx: mu_Context, id: Int, rect: mu_Rect, color: mu_Color): Void;

	public function mu_layout_row(ctx: mu_Context, items: Int, widths: Int, height: Int): Void;
	public function mu_layout_width(ctx: mu_Context, width: Int): Void;
	public function mu_layout_height(ctx: mu_Context, height: Int): Void;
	public function mu_layout_begin_column(ctx: mu_Context): Void;
	public function mu_layout_end_column(ctx: mu_Context): Void;
	public function mu_layout_set_next(ctx: mu_Context, r: mu_Rect, relative: Int): Void;
	public function mu_layout_next(ctx: mu_Context): mu_Rect;

	public function mu_draw_control_frame(ctx: mu_Context, id: mu_Id, rect: mu_Rect, colorid: Int, opt: Int): Void;
	public function mu_draw_control_text(ctx: mu_Context, str: String, rect: mu_Rect, colorid: Int, opt: Int): Void;
	public function mu_mouse_over(ctx: mu_Context, rect: mu_Rect): Int;
	public function mu_update_control(ctx: mu_Context, id: mu_Id, rect: mu_Rect, opt: Int): Void;

	public function mu_text(ctx: mu_Context, text: String): Void;
	public function mu_label(ctx: mu_Context, text: String): Void;
	public function mu_button(ctx: mu_Context, label: String, icon: Int = 0, opt: Int = MU_OPT_ALIGNCENTER): Int;
	public function mu_checkbox(ctx: mu_Context, label: String, state: Int): Int;
	public function mu_textbox_raw(ctx: mu_Context, buf: String, bufsz: Int, id: mu_Id, r: mu_Rect, opt: Int): Int; // TODO buf is probably not a string
	public function mu_textbox(ctx: mu_Context, buf: String, bufsz: Int, opt: Int = 0): Int; // TODO buf is probably not a string
	public function mu_slider(ctx: mu_Context, value: mu_Real, low: mu_Real, high: mu_Real, step: mu_Real = 0, fmt: String = MU_SLIDER_FMT, opt: Int = MU_OPT_ALIGNCENTER): Int;
	public function mu_number(ctx: mu_Context, value: mu_Real, step: mu_Real, fmt: String = MU_SLIDER_FMT, opt: Int = MU_OPT_ALIGNCENTER): Int; 
	public function mu_header(ctx: mu_Context, label: String, opt: Int = 0): Int;
	public function mu_begin_treenode(ctx: mu_Context, label: String, opt: Int = 0): Int;
	public function mu_end_treenode(ctx: mu_Context): Void;
	public function mu_begin_window(ctx: mu_Context, title: String, rect: mu_Rect, opt: Int = 0): Int;
	public function mu_end_window(ctx: mu_Context): Void;
	public function mu_open_popup(ctx: mu_Context, name: String): Void;
	public function mu_begin_popup(ctx: mu_Context, name: String): Int;
	public function mu_end_popup(ctx: mu_Context): Void;
	public function mu_begin_panel(ctx: mu_Context, name: String, opt: Int = 0): Void;
	public function mu_end_panel(ctx: mu_Context): Void;
}
