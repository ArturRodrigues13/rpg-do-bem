mstack = new MenuStack();

global.battle = new Battle({
	allyNames: ["knight0", "mage0"], // TODO: salvar em algum lugar quais são os aliados atuais
});
battle = global.battle;

battle.timeStep = 0.05;
