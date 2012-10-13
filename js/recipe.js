var malts=[
{"name":"CaraFoam",			 "srm":1},
{"name":"UK Pilsner 2-Row", "yield": 77.9, "srm": 1},
{"name":"Malted Oats",	 "yield":80.0, "srm": 1},
{"name":"2-Row Malt",	 "yield":77.9, "srm": 2},
{"name":"6-Row Malt",	 "yield":75.7, "srm": 2},
{"name":"Golden Promise",			 "srm":2},
{"name":"Belgian Pilsner 2-Row","yield": 77.9, "srm":	 2},
{"name":"German Pilsner 2-Row","yield":	 80.0, "srm":	 2},
{"name":"Lager Malt","yield":	 	 82.2	 , "srm": 2},
{"name":"Belgian Wheat","yield":	 	 80.0	 , "srm": 2},
{"name":"German Wheat","yield":	 	 84.4	 , "srm": 2},
{"name":"White Wheat","yield":	 	 86.7	 , "srm": 2},
{"name":"CaraPils","yield":	 	 71.4	 , "srm": 2},
{"name":"Dextrine Malt","yield":	 	 71.4	 , "srm": 2},
{"name":"Acid Malt","yield":	 	 58.4	 , "srm": 3},
{"name":"Peated Malt","yield":	 	 73.6	 , "srm": 3},
{"name":"Maris Otter","yield":	 	 82.2	 , "srm": 3},
{"name":"Optic","yield":	 ,			 "srm":3}, "srm": ,},
{"name":"Briess Pale Ale Malt","yield":	 			 , "srm": 4},
{"name":"English Mild","yield":	 	 	 80.0	 , "srm": 4},
{"name":"Vienna Malt","yield":	 	 	 77.9	 , "srm": 4},
{"name":"Toasted Malt","yield":	 	 	 62.8	 , "srm": 5},
{"name":"Dark Wheat","yield":	 	 	 84.4	 , "srm": 9},
{"name":"Munich Malt","yield":	 	 	 80.0	 , "srm": 9},
{"name":"Smoked Malt","yield":	 	 	 80.0	 , "srm": 9},
{"name":"Crystal 10","yield":	 	 73.55	 , "srm": 10},
{"name":"Carastan 15","yield":	 	 73.55	 , "srm": 15},
{"name":"Munich 10","yield":	 	 75.7	 , "srm": 10},
{"name":"Crystal 20","yield":	 	 	 73.55	 , "srm": 20},
{"name":"Munich 20","yield":	 	 	 75.7	 , "srm": 20},
{"name":"CaraRed","yield":	 	 75.7	 , "srm": 20},
{"name":"Melanoidin Malt","yield":	 	 	 80.0	 , "srm": 20},
{"name":"Amber Malt","yield":	 	 	 75.7	 , "srm": 22},
{"name":"CaraVienna","yield":	 	 	 73.6	 															, "srm"::22 	},
{"name":"Belgian Biscuit Malt","yield":	 	 	 77.9	 , "srm": 23},
{"name":"Brumalt","yield":	 	 	 71.4	 , "srm": 23},
{"name":"Gambrinus Honey Malt","yield":	 	 	 80.0	 , "srm": 25},
{"name":"Belgian Aromatic","yield":	 	 	 77.9	 , "srm": 26},
{"name":"Victory Malt","yield":	 	 	 73.6	 , "srm": 28},
{"name":"Crystal 30","yield":	 	 	 73.55	 , "srm": 30},
{"name":"Carastan 35","yield":	 	 	 73.55	 , "srm": 35},
{"name":"Crystal 40","yield":	 	 	 73.55	 , "srm": 40},
{"name":"Caramel Wheat Malt","yield":	 	 	 75.7	 , "srm": 46},
{"name":"Special Roast","yield":	 	 71.4	 , "srm": 50},
{"name":"CaraMunich","yield":	 	 	 71.4	 , "srm": 56},
{"name":"Crystal 60","yield":	 	 	 73.55	 , "srm": 60},
{"name":"Brown Malt","yield":	 	 	 69.2	 , "srm": 65},
{"name":"Crystal 80","yield":	 	 73.55	 , "srm": 80},
{"name":"Crystal 90","yield":	 	 73.55	 , "srm": 90},
{"name":"Crystal 120","yield":	 	 73.55	 , "srm": 120},
{"name":"CaraAroma","yield":	 	 75.7	 , "srm": 130},
{"name":"Crystal 150","yield":	 	 75.7	 , "srm": 150},
{"name":"Special B","yield":	 	 64.9	 , "srm": 180},
{"name":"Chocolate Rye Malt","yield":	 	 67.1	 , "srm": 250},
{"name":"Roasted Barley","yield":	 	 	 54.1	 , "srm": 300},
{"name":"Carafa I","yield":	 	 69.2	 , "srm": 337},
{"name":"Chocolate Malt","yield":	 	 	 73.6	 , "srm": 350},
{"name":"Chocolate Wheat Malt","yield":	 	 	 71.4	 , "srm": 400},
{"name":"Carafa II","yield":	 	 69.2	 , "srm": 412},
{"name":"Black Patent Malt","yield":	 	 	 54.1	 , "srm": 500},
{"name":"Black Barley","yield":	 	 	 54.1	 , "srm": 500},
{"name":"Carafa III","yield":	 	 	 69.2	 , "srm": 525}
];

var hops=[
	{"name":"Admiral", "origin": "UK", "alpha": "13-16%", "beta": "5.60%", "notes": "Good high alpha acid hop used mainly as a replacement for Target. Not as harsh as Target with a more pleasing hoppy aroma.", "usage": "Bittering"},
	{"name":"Ahtanum", "origin": "U.S.", "alpha": "5-7%", "beta": "5.25%", "notes": "Very distinctive hop from the US. Has good aromatic properties and moderate bittering quality. Has a Cascade like quality.", "usage": "Aroma/Bittering"},
	{"name":"Amarillo Gold", "origin": "U.S.", "alpha": "8-11%", "beta": "6%", "notes": "High alpha hop with a similar floral like quality as Cascade.", "usage": "Bittering/Aroma"},
	{"name":"Bramling Cross", "origin": "UK", "alpha": "5-7%", "beta": "3%", "notes": "Very distinctive character that has notes of blackcurrant and spicy citrus. Has very good potential for cask conditioned beers and dry hopping.", "usage": "Aroma"},
	{"name":"Brewer’s Gold", "origin": "Germany", "alpha": "5-8%", "beta": "3.70%", "notes": "Produces a balanced bitterness and is used in traditional lagers and also found a place in some seasonal ales.", "usage": "Bittering"},
	{"name":"Cascade", "origin": "US", "alpha": "4-6%", "beta": "6%", "notes": "An easily recognisable grapefruit character. It has become very popular because of the floral charcter it seems to impart to any beer, dark or pale", "usage": "Aroma/Bittering"},
	{"name":"Centennial", "origin": "US", "alpha": "8-10%", "beta": "4%", "notes": "A floral, clean and cirus aroma often said to liken it to Cascade. High alpha then Cascade give it better bittering qualities", "usage": "Bittering"},
	{"name":"Challenger", "origin": "UK", "alpha": "5-9%", "beta": "4%", "notes": "Good well rounded hop that lends itself to British Ales. Good for both aroma and bittering and added later in the boil gives a fruity crisp character", "usage": "Aroma/Bittering"},
	{"name":"Chinook", "origin": "US", "alpha": "11-14%", "beta": "3.60%", "notes": "A high alpha hop that provides strong grapefruit character to the finished beer. Used often in stouts and porters because of the prominent spicy character", "usage": "Bittering"},
	{"name":"Cluster", "origin": "US", "alpha": "6-8%", "beta": "4.80%", "notes": "Gives good depth to the finished beer. Has a sharp character but also deep fruity qualities", "usage": "Aroma"},
	{"name":"Columbus (Tomahawk)", "origin": "US", "alpha": "14-17%", "beta": "5%", "notes": "Newer high alpha variety of hop and primarily used as a bittering hop because of this. Has been used as a late addition and is very aromatic.", "usage": "Bittering"},
	{"name":"Crystal", "origin": "US", "alpha": "3-5%", "beta": "5.20%", "notes": "Very clean Hallertau character. Delicate and used often in lagers", "usage": "Aroma"},
	{"name":"First Gold", "origin": "UK", "alpha": "6-8%", "beta": "3.50%", "notes": "Used both as a bittering hop and as a late or dry hop. Retains many of the qualities of the Goldings varities but also an added minty and citrus note", "usage": "Bittering/Aroma"},
	{"name":"Fuggles", "origin": "UK", "alpha": "3-6%", "beta": "2%", "notes": "A delicate, minty, grassy aroma present in many traditional English ales. Often paired with Goldings", "usage": "Aroma/Bittering"},
	{"name":"Galena", "origin": "US", "alpha": "10-14%", "beta": "7.50%", "notes": "General bittering hops used in many American beers. Clean, strong bitterness and fruity aroma", "usage": "Bittering"},
	{"name":"Goldings, East Kent", "origin": "UK", "alpha": "4-7%", "beta": "3.50%", "notes": "Traditional English aroma variety hop with a long history of being used in English brewing. Used for is delicate, smooth qualities", "usage": "Aroma"},
	{"name":"Green Bullet", "origin": "New Zealand", "alpha": "11-15%", "beta": "7%", "notes": "Distinctive floral and raison character hop. Excellent aroma and bittering qualities. Used to good effect in Australia and NZ award winning beers.", "usage": "Bittering/Aroma"},
	{"name":"Hallertauer Hersbrucker", "origin": "German", "alpha": "2-5%", "beta": "6%", "notes": "Delicate aroma hop used in wide range of lagers and light ales. Produces a floral, mild and pleasant aroma.", "usage": "Aroma"},
	{"name":"Hallertauer Mittelfrueh", "origin": "Germany", "alpha": "4-6%", "beta": "4.60%", "notes": "Used in similar styles to Hersbrucker. With similar aroma qualities", "usage": "Aroma"},
	{"name":"Hallertauer, New Zealand", "origin": "New Zealand", "alpha": "7-11%", "beta": "3%", "notes": "Bred from the classic Hallertauer Mittelfruer. Floral and Vanilla flavour goes well in lighter beers", "usage": "Bittering/Aroma"},
	{"name":"Horizon", "origin": "US", "alpha": "10-17%", "beta": "7.50%", "notes": "Good bittering hop that provide a subtle, clean finish", "usage": "Bittering"},
	{"name":"Liberty", "origin": "US", "alpha": "4-6%", "beta": "3.50%", "notes": "Bred from the Hallertau type hops and has a subtle spicy finish but also has an added citrus note. As with Halletau used frequently in lagers", "usage": "Aroma"},
	{"name":"Mt. Hood", "origin": "US", "alpha": "3-6%", "beta": "6.30%", "notes": "Bred as a substitute for Hallertauer Mittlefrueh in the US. Flavour attributes have been noted as mild, herbal with a clean character", "usage": "Aroma"},
	{"name":"Northdown", "origin": "UK", "alpha": "6-10%", "beta": "5.50%", "notes": "Excellent dual hop that has both good bittering and aroma properties. It has a crisp fruit and some say straw quality and is similar to Challenger but richer.", "usage": "Bittering/Aroma"},
	{"name":"Northern Brewer", "origin": "Germany", "alpha": "6-10%", "beta": "4%", "notes": "Also called Hallertauer Northern Brewer. It is a good bittering hop and is uesed notably in Anchor Steam and in Old Peculiar", "usage": "Bittering/Aroma"},
	{"name":"Nugget", "origin": "US", "alpha": "11-13%", "beta": "5%", "notes": "A strong bittering hop from the US that has a herbal spiciness that some say make it a good aroma hop also.", "usage": "Bittering"},
	{"name":"Pacific Gem", "origin": "New Zealand", "alpha": "13-18%", "beta": "8.20%", "notes": "High alpha bittering hop that has fruity qualities like that of blackberries. It also has hints of wood that give an oaky feel to the beer.", "usage": "Bittering"},
	{"name":"Pearle", "origin": "Germany", "alpha": "6-12%", "beta": "4.75%", "notes": "A German hop that has similar character to Mittlefruh albeit with high alpha acids. It has a pleasant aroma and minty qualities", "usage": "Aroma/Bittering"},
	{"name":"Phoenix", "origin": "UK", "alpha": "9-13%", "beta": "4.60%", "notes": "Good substitute for other bittering hops but disappointing aroma profile.", "usage": "Bittering"},
	{"name":"Pilgrim", "origin": "UK", "alpha": "9-13%", "beta": "4.70%", "notes": "New variety from Wye College in 2001. Bred as a dual purpose hop or a replacement for high alpha hops", "usage": "Bittering"},
	{"name":"Pioneer", "origin": "UK", "alpha": "8-10%", "beta": "3.75%", "notes": "Unusual but pleasant citrus like qualities that give good aroma to the finished beer", "usage": "Bittering/Aroma"},
	{"name":"Pride of Ringwood", "origin": "Australia", "alpha": "7-11%", "beta": "5.75%", "notes": "General purpose bittering hops for Australian beers notable beers include Fosters. It has a distinct citrus aroma", "usage": "Bittering"},
	{"name":"Progress", "origin": "UK", "alpha": "4-7%", "beta": "2.10%", "notes": "Similar hop to Fuggle but with a sweeter flavour and softer bitterness character. Good potential for both bitterness and aroma", "usage": "Aroma"},
	{"name":"Saaz", "origin": "Czech Republic", "alpha": "3-6%", "beta": "3.50%", "notes": "Regarded as the only hop for brewing Pilsner. Used most commonly in European lagers. Provides a mild and almost earthy flavour.", "usage": "Aroma"},
	{"name":"Santiam", "origin": "US", "alpha": "5-7%", "beta": "7%", "notes": "Considered an excellant aroma hop that has similar character to Tettnanger", "usage": "Aroma"},
	{"name":"Spalt Select", "origin": "German", "alpha": "3-6%", "beta": "3.50%", "notes": "Bred from Hallertauer Mittelfrueh and Spalt in Germany. Provides classic lager style aroma to the beer", "usage": "Aroma"},
	{"name":"Simcoe", "origin": "US", "alpha": "12-14%", "beta": "4.50%", "notes": "High alpha bitterng hops with good citrus aroma characteristics.", "usage": "Bittering"},
	{"name":"Sterling", "origin": "US", "alpha": "5-9%", "beta": "5%", "notes": "Flavor is a cross between Saaz and Mt Hood. Good aroma hop that has a noble type spicy flavour.", "usage": "Both"},
	{"name":"Styrian Goldings", "origin": "Slovenia", "alpha": "3-6%", "beta": "2.90%", "notes": "Well known variety of hop that is similar to Fuggle in many ways but also with some unique characteristics. Has a perfume like quality that is good for lighter coloured beers.", "usage": "Aroma"},
	{"name":"Target", "origin": "UK", "alpha": "8-13%", "beta": "5%", "notes": "High alpha variety that has similar qualities to Admiral but is slightly more harsh and not ideal for aroma purposes", "usage": "Bittering"},
	{"name":"Tettnang", "origin": "Germany", "alpha": "3-6%", "beta": "4%", "notes": "Excellent traditional aroma hop that is prized in German lagers and wheat beers.", "usage": "Aroma"},
	{"name":"Vanguard", "origin": "US", "alpha": "4-6%", "beta": "6%", "notes": "Bred from Hallertauer Mittelfrueh and used as an aroma hop. Said to have a herbal quality", "usage": "Aroma"},
	{"name":"Warrior", "origin": "US", "alpha": "15-17%", "beta": "4-6%", "notes": "High alpha hop from Yakima Chief Ranches. Good bittering potential and has citrus like qualities", "usage": "Bittering"},
	{"name":"Williamette", "origin": "US", "alpha": "3-6%", "beta": "3-4.5%", "notes": "Delicate dark fruity flavours and grassy quality that make it similar to Fuggles. Excellent as an aroma hop and widley used as a replacement to Fuggle in America", "usage": "Aroma"}
];

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
function displayRecipe(repo,recipe_info,renderElem,templateElem,callback) {
	$.views.helpers({
		format_gravity: function(val) {
			return val.toFixed(3);
		}
	})
	// TODO: use commit_sha to get the git version of the recipe for this batch
	$.getJSON(github_blob_url(repo,recipe_info.blob),
		null,
		function(data,textStatus,xhr) {
			var recipe=$.parseJSON(decode64(data.content));
			
			// Scale recipe, if specified
			var scale_factor=1;
			if (recipe_info.batch_size) {
				scale_factor=recipe_info.batch_size / recipe.batch_size;
			}
			
			recipe.batch_size *= scale_factor;
			
			// Scale fermentables
			recipe.ingredients.fermentables.total_weight *= scale_factor;
			for (var i=0; i < recipe.ingredients.fermentables.list.length; ++i) {
				recipe.ingredients.fermentables.list[i].amount *= scale_factor;
			}
			// Scale hops
			recipe.ingredients.hops.total_weight *= scale_factor;
			for (var i=0; i < recipe.ingredients.hops.first_wort.length; ++i) {
				recipe.ingredients.hops.first_wort[i].amount *= scale_factor;
			}
			for (var i=0; i < recipe.ingredients.hops.boil.length; ++i) {
				recipe.ingredients.hops.boil[i].amount *= scale_factor;
			}
			for (var i=0; i < recipe.ingredients.hops.aroma.length; ++i) {
				recipe.ingredients.hops.aroma[i].amount *= scale_factor;
			}
			for (var i=0; i < recipe.ingredients.hops.dry_hop.length; ++i) {
				recipe.ingredients.hops.dry_hop[i].amount *= scale_factor;
			}
			// Scale miscellaneous
			for (var i=0; i < recipe.ingredients.miscellaneous.length; ++i) {
				recipe.ingredients.miscellaneous[i].amount *= scale_factor;
			}
			
			// Sort
			recipe.ingredients.fermentables.list.sort(function(a,b) {return b.amount - a.amount;});
			recipe.ingredients.hops.first_wort.sort(function(a,b) {return b.amount - a.amount;});
			recipe.ingredients.hops.boil.sort(function(a,b) {return b.amount - a.amount;});
			recipe.ingredients.hops.aroma.sort(function(a,b) {return b.amount - a.amount;});
			recipe.ingredients.hops.dry_hop.sort(function(a,b) {return b.amount - a.amount;});
			recipe.ingredients.miscellaneous.sort(function(a,b) {return b.amount - a.amount;});
			
			recipe.calc_og=calc_og_gu(recipe) / 1000 + 1;
			recipe.calc_fg=calc_fg_gu(recipe) / 1000 + 1;
			recipe.total_ppg=total_ppg(recipe);
				
			// From http://www.mrmalty.com/pitching.php:
			// 		
			// (0.75 million) X (milliliters of wort) X (degrees Plato of the wort)  
			// 			
			// 2x as much for lagers
		
			recipe.yeast_starter=new Object;
			recipe.yeast_starter.viability_pct=75;
			recipe.yeast_starter.cells_reqd=0.75 * (recipe.batch_size * 1000) * (calc_og_gu(recipe) / 4) / 1000;
			// Twice as much for lagers, if we know this is a lager beer, double it. Ideally, we'd
			// check the yeast, but there's no signifier of ale/lager for the yeast in the beer XML doc.
			if (recipe.styles && recipe.styles.length && (recipe.styles[0].category < 6))
				recipe.yeast_starter.cells_reqd *= 2;
			
			recipe.yeast_starter.ml_reqd=recipe.yeast_starter.cells_reqd / 2.5 * (1 / (recipe.yeast_starter.viability_pct/100));
				
			recipe.ingredients.miscellaneous.sort(function(a,b) {return b.time - a.time;});
				
			renderElem.html(templateElem.render(recipe));
			
			$('#edit_button').toggle(
				function(evt) {
					$('.nonedit_version').toggle("fade","linear",400,function(){
						$(this).next('.edit_version').toggle("fade","linear",400);
					})
				},
				function(evt) {
					$('.edit_version').toggle("fade","linear",400,function(){
						$(this).prev('.nonedit_version').toggle("fade","linear",400);
					})
				}
			);
			
			$('.weightField').change(function(evt) {
				var amount_g=parseAmount($(this).val());
				
				if ($(this).hasClass("metric")) {
					$(this).val(metricFormat(amount_g));
					$(this).prev(':text').val(usFormat(amount_g));
				}
				else {
					$(this).val(usFormat(amount_g));
					$(this).next(':text.metric').val(metricFormat(amount_g));
				}

				if ($(this).parents('#hops').size()) {
					// Change the total weight
					console.log('changed a hops amount');
				}
					
				if ($(this).parents('#fermentables').size()) {
					// Change the total weight
					// Change the percentage column too
					console.log('changed a fermentable amount');
					var sum=0;
					$('#fermentables .weightField').not('.metric').each(function(){
						sum+=parseAmount($(this).val());
					});
					$('#fermentables .total_weight').html(
						usFormat(sum,true) + " (" + metricFormat(sum) + ")"
					);
				}
			});
			
			if (callback)
				callback(recipe);
		}
	)
}

function fahrenheitToCelsius(f) {return (f - 32) * 5 / 9;}
function celsiusToFahrenheit(c) {return (9 / 5 * c) + 32;}
function kg2lbs(kg) { return kg * 2.20462; }
function lbs2kg(lbs) { return lbs / 2.20462; }
function g2oz(g) { return g * 0.035274; }
function g2lb(g) { return g2oz(g) / 16; }
function oz2g(oz) { return oz / 0.035274; }
function liters2gallons(l) { return l * 0.264172; }
function gallons2liters(g) { return g / 0.264172; }
function gu2sg(gu) { return gu / 1000 + 1; }
function sg2gu(sg) { return (sg - 1) * 1000; }
function metricFormat(g) {
	if (g < 1000)
		return g.toFixed(0) + "g";
	return (g / 1000).toFixed(2).replace(/\.?0+$/,'') + "kg";
}
function usFormat(g,decimalOnly) {
	var decimal=false;
	if (arguments.length==2)
		decimal=decimalOnly;
		
	if (g < 453.592) // Less than 1 pound?
		return (g2oz(g) % 16).toFixed(2).replace(/\.?0+$/,'') + " oz";
	else if (decimal)
		return g2lb(g).toFixed(2) + " lbs";
	else if (g2oz(g).toFixed(0) % 16 > 0)
		return g2lb(g).toFixed(0) + " lbs " + (g2oz(g) % 16).toFixed(0) + " oz";
	return g2lb(g).toFixed(0) + " lbs";
}

// Parse the amount as written in "human format", i.e., 3.2oz, 14kg, etc.
function parseAmount(string) {
	var re=/(\d+(?:\.\d+)?)\s*(lbs?|ozs?|g|kg)/gi;
	var matches;
	var amount_g=0;
	while ((matches=re.exec(string)) != null) {
		var qty=parseFloat(matches[1])
		if (matches[2]=="kg") 
			amount_g+=qty * 1000;
		else if (matches[2]=="lbs" || matches[2]=="lb") 
			amount_g+=lbs2kg(qty) * 1000;
		else if (matches[2]=="ozs" || matches[2]=="oz") 
			amount_g+=oz2g(qty);
		else
			amount_g+=qty;
	}
	return amount_g;
}
