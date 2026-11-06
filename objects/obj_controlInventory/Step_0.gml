var gk = global.keys;

if(mstack.isEmpty()) {
	if(gk.inventory.isPressed()) {
		mstack.push(new InventoryMenu(mstack));
		show_debug_message("eu")
	}
} else {
	mstack.peek().onStep();
}