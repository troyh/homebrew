var access_token="5b718b4156cce4d7929c4309980d273a1f7f69bc";

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

function github_blob_url(repo,blob_sha)  {
	return "https://api.github.com/repos/"+repo.user+"/"+repo.repo+"/git/blobs/"+blob_sha;
}

function github_commit(repo,files,message) {

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
	
	$.ajaxSetup({
		beforeSend: function(jqXHR,settings) {
			// console.log("AJAX:" + settings.url);
		},
		headers: {
			"Authorization": "token " + access_token
		}
	})

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
							parents: [ ref.object.sha ]
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
