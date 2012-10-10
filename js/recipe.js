 var keyStr = "ABCDEFGHIJKLMNOP" +
             "QRSTUVWXYZabcdef" +
             "ghijklmnopqrstuv" +
             "wxyz0123456789+/" +
               "=";
function encode64(input) {
   input = escape(input);
   var output = "";
   var chr1, chr2, chr3 = "";
   var enc1, enc2, enc3, enc4 = "";
   var i = 0;

   do {
      chr1 = input.charCodeAt(i++);
      chr2 = input.charCodeAt(i++);
      chr3 = input.charCodeAt(i++);

      enc1 = chr1 >> 2;
      enc2 = ((chr1 & 3) << 4) | (chr2 >> 4);
      enc3 = ((chr2 & 15) << 2) | (chr3 >> 6);
      enc4 = chr3 & 63;

      if (isNaN(chr2)) {
         enc3 = enc4 = 64;
      } else if (isNaN(chr3)) {
         enc4 = 64;
      }

      output = output +
         keyStr.charAt(enc1) +
         keyStr.charAt(enc2) +
         keyStr.charAt(enc3) +
         keyStr.charAt(enc4);

      chr1 = chr2 = chr3 = "";
      enc1 = enc2 = enc3 = enc4 = "";
   } while (i < input.length);

   return output;
}

function decode64(input) {
   var output = "";
   var chr1, chr2, chr3 = "";
   var enc1, enc2, enc3, enc4 = "";
   var i = 0;

   // remove all characters that are not A-Z, a-z, 0-9, +, /, or =
   var base64test = /[^A-Za-z0-9\+\/\=]/g;
   if (base64test.exec(input)) {
      // alert("There were invalid base64 characters in the input text.\n" +
      //       "Valid base64 characters are A-Z, a-z, 0-9, '+', '/',and '='\n" +
      //       "Expect errors in decoding.");
   }
   input = input.replace(/[^A-Za-z0-9\+\/\=]/g, "");
   do {
      enc1 = keyStr.indexOf(input.charAt(i++));
      enc2 = keyStr.indexOf(input.charAt(i++));
      enc3 = keyStr.indexOf(input.charAt(i++));
      enc4 = keyStr.indexOf(input.charAt(i++));

      chr1 = (enc1 << 2) | (enc2 >> 4);
      chr2 = ((enc2 & 15) << 4) | (enc3 >> 2);
      chr3 = ((enc3 & 3) << 6) | enc4;

      output = output + String.fromCharCode(chr1);

      if (enc3 != 64) {
         output = output + String.fromCharCode(chr2);
      }

      if (enc4 != 64) {
         output = output + String.fromCharCode(chr3);
      }

      chr1 = chr2 = chr3 = "";
      enc1 = enc2 = enc3 = enc4 = "";
   } while (i < input.length);

   return unescape(output);
}

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
				// Parse the amount
				var re=/(\d+(?:\.\d+)?)\s*(lbs?|ozs?|g|kg)/gi;
				var matches;
				var amount_g=0;
				while ((matches=re.exec($(this).val())) != null) {
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
				if ($(this).hasClass("metric")) {
					$(this).val(metricFormat(amount_g));
					$(this).prev(':text').val(usFormat(amount_g));
				}
				else {
					$(this).val(usFormat(amount_g));
					$(this).next(':text.metric').val(metricFormat(amount_g));
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
	return (g / 1000).toFixed(2) + "kg";
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
