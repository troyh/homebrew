function total_ppg(recipe) {
	var total=0;
	for (var i = 0; i < recipe.ingredients.fermentables.list.length; ++i) {
		total += recipe.ingredients.fermentables.list[i].amount * 2.20462 * (recipe.ingredients.fermentables.list[i].yield / 100 * 46);
	}
	return total;
}
function calc_og_gu(recipe) {
	return (total_ppg(recipe) * recipe.efficiency / (recipe.batch_size * 0.264172)) / 100;
}
function calc_fg_gu(recipe) {
	return calc_og_gu(recipe) - ((recipe.efficiency / 100) * calc_og_gu(recipe));
}
function displayRecipe(id,renderElem,templateElem,callback) {
	$.views.helpers({
		format_gravity: function(val) {
			return val.toFixed(3);
		}
	})
	// TODO: use commit_sha to get the git version of the recipe for this batch
	$.getJSON("recipes/" + id + ".json",
		null,
		function(data,textStatus,xhr) {
			data.calc_og=calc_og_gu(data) / 1000 + 1;
			data.calc_fg=calc_fg_gu(data) / 1000 + 1;
			data.total_ppg=total_ppg(data);
				
			// From http://www.mrmalty.com/pitching.php:
			// 		
			// (0.75 million) X (milliliters of wort) X (degrees Plato of the wort)  
			// 			
			// 2x as much for lagers
		
			data.yeast_starter=new Object;
			data.yeast_starter.viability_pct=75;
			data.yeast_starter.cells_reqd=0.75 * (data.batch_size * 1000) * (calc_og_gu(data) / 4) / 1000;
			// Twice as much for lagers, if we know this is a lager beer, double it. Ideally, we'd
			// check the yeast, but there's no signifier of ale/lager for the yeast in the beer XML doc.
			if (data.styles.length && (data.styles[0].category < 6))
				data.yeast_starter.cells_reqd *= 2;
			
			data.yeast_starter.ml_reqd=data.yeast_starter.cells_reqd / 2.5 * (1 / (data.yeast_starter.viability_pct/100));
				
			data.ingredients.miscellaneous.sort(function(a,b) {return b.time - a.time;});
				
			renderElem.html(templateElem.render(data));
			
			if (callback)
				callback(data);
		}
	)
}

