var access_token="5b718b4156cce4d7929c4309980d273a1f7f69bc";

$.ajaxSetup({
	beforeSend: function(jqXHR,settings) {
		// console.log("AJAX:" + settings.url);
	},
	headers: {
		"Authorization": "token " + access_token
	}
})

jQuery.extend({
   postJSON: function(url, data, callback) {
     return jQuery.ajax({
       type: "POST",
       url: url,
       data: JSON.stringify(data),
       success: callback,
       dataType: "json",
       contentType: "application/json",
       processData: false
     });
   }
 });

var repo={
	user: (localStorage.getItem('github_repo_user') || (location.host.split('.'))[0] || null),
	repo: (localStorage.getItem('github_repo_name') || (location.pathname.split('/'))[1] || null),
	branch:"data"
}

function github_api_url() {
	return "https://api.github.com/repos/"+repo.user+"/"+repo.repo + "/git";
}
function github_blob_url(blob_sha)  {
	return github_api_url() + "/blobs/"+blob_sha;
}

function github_files_tree(callback) {
	$.getJSON(github_api_url() + "/refs/heads/data",null,function(data,textStatus,xhr){
		$.getJSON(github_api_url() + "/trees/" + data.object.sha + "?recursive=1",null,function(data,textStatus,xhr){
			callback(data.tree);
		})
	});
}
function github_get_latest_version(filepath,callback) {
	$.getJSON(github_api_url()+"/refs/heads/"+repo.branch,
		null,
		function(data,textStatus,xhr) {
			$.getJSON(data.object.url,
				null,
				function (data,textStatus,xhr) {
					$.getJSON(data.tree.url+"?recursive=1",
						null,
						function(data,textStatus,xhr){
							// Iterate tree looking for filepath
							for (var i=0; i < data.tree.length; ++i) {
								if (data.tree[i].type=="blob" && data.tree[i].path==filepath) {
									$.getJSON(data.tree[i].url,null,function(data,textStatus,xhr){
										callback($.parseJSON(decode64(data.content)));
									});
									break;
								}
							}
						}
					);
				}
			);
		}
	);
}

function github_commit(files,message) {

	// console.log(files);
	var files_tree=[];
	for (var i=0; i< files.length; ++i) {
		files_tree.push({
			path: files[i].filepath,
			mode: "100644",
			type: "blob",
			content: files[i].content
		});
	}
	
	// console.log('Committing...');
	$.getJSON("https://api.github.com/repos/"+repo.user+"/"+repo.repo+"/git/refs/heads/"+repo.branch,null,function(ref) {
		// console.log("refs response:");
		// console.log(ref);
		$.getJSON("https://api.github.com/repos/"+repo.user+"/"+repo.repo+"/git/trees/"+ref.object.sha,null,function(tree) {
			// console.log("trees response:");
			// console.log(tree);
			var postdata=				{
					base_tree: tree.sha,
					tree: files_tree
				};
				// console.log("postdata:");
				// console.log(postdata);
			$.postJSON("https://api.github.com/repos/"+repo.user+"/"+repo.repo+"/git/trees",
				postdata,
				function(new_tree) {
					// console.log("trees response:");
					// console.log(new_tree);
					$.postJSON("https://api.github.com/repos/"+repo.user+"/"+repo.repo+"/git/commits",
						{
							message: message,
							tree: new_tree.sha,
							parents: [ tree.sha ]
						},
						function(commit) {
							// console.log("Commit response:");
							// console.log(commit);
							$.postJSON("https://api.github.com/repos/"+repo.user+"/"+repo.repo+"/git/refs/heads/"+repo.branch,
								{
										sha: commit.sha
								},
								function(ref) {
										// console.log(ref);
								}
							)
						},
						"json"
					);
				},
				"json"
			);
		});
	});
	
	// for (var file in files) {
	// 	var pathparts=file.filepath.split("/");
	// 	var filename=pathparts.pop();
	// 	var dirname=pathparts;
	// 	
	// 	// Find the current place in the tree for this filepath (if it exists)
	// 	var found=false;
	// 	for (obj in tree.tree) {
	// 		if (obj.type=="blob" && obj.path==file.filepath) {
	// 			// Change the sha
	// 			obj.content=file.content;
	// 			delete obj.sha;
	// 			found=true;
	// 			break;
	// 		}
	// 	}
	// 	if (!found) {
	// 		// Create an object in the tree
	// 		tree.tree.push({
	// 			type: "blob",
	// 			path: file.filepath,
	// 			mode: "100644",
	// 			content=file.content
	// 		});
	// 	}
	// }
}

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
