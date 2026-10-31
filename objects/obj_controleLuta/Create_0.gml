mstack = new MenuStack();

var battleData = global.battleData;
if (battleData == undefined) {
	show_error("Battle data missing!", true);
}

battle = new Battle({
	allyNames: ["knight0", "mage0", "sup"], // TODO: salvar em algum lugar quais são os aliados atuais
	enemies: battleData.enemies,
});
global.battle = battle;
battle.timeStep = 0.02; // TODO: tirar isso daqui?
