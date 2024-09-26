var bannerUrl = "https://i.imgur.com/EB8ozwT.png"

$(function(){

	$('.users').on('click', '.spec', function(){

		let target = $(this).data('spectate');

		let player = $('.spectate').attr('id');

		if (target == player) {
			alert("You can't spectate yourself!");
		} else {
			$('.spectate').fadeOut();
			$('.settings').fadeOut();
			$.post('http://rsp/select', JSON.stringify({id: target}));
		}

	});


	$('.header').on('click', '#close', function(){
		$('.spectate').fadeOut();
		$('.settings').fadeOut();
		$.post('http://rsp/quit');
	});

	window.addEventListener('message', function(event){
		if (event.data.type == "show"){
			let data = event.data.data;
			let player = event.data.player;
			$('.spectate').attr('id', player);
			populate(data);
			setTimeout(function(){
				$('.spectate').fadeIn();

			}, 200)
		}
	});

	$(document).keyup(function(e){
		if (e.keyCode == 27){
			$('.spectate').fadeOut();
			$('.settings').fadeOut();
			$.post('http://rsp/close');
		}
	})

});

function populate(data){
	$('.spectate .users').html('');

	data.sort(function(a, b) {
		let idA = a.id;
		let idB = b.id;
		if (idA < idB)
	        return -1 
	    if (idA > idB)
	        return 1
	    return 0
	});

	for (var i = 0; i < data.length; i++) {
		let id = data[i].id;
		let name = 'Tribute #';
		let element = 	'<div class="user">' +
							
							'<span class="user-name">' + name + '</span>' +
							'<span class="user-id">' + id + '</span>' +
							'<span class="user-actions">' +
								'<button class="spec" data-spectate="' + id + '">Select</button>' +
							'</span>' +
						'</div>';

		$('.spectate .users').append(element);
	}

}


var value_user = false

function ValueFromUser() {
    value_user = true
}

function Updatebanner() {
    if (value_user) {
        var dimension_value = document.getElementById("file-input")
        var banner = document.getElementById("banner")

        if (dimension_value.value != "") {
            banner.src = dimension_value.value
            bannerUrl = dimension_value.value
            $.post('http://banner/save_data', JSON.stringify({
                banner: bannerUrl
            }));
        } else {
            banner.src = "https://i.imgur.com/EB8ozwT.png"
            bannerUrl = "https://i.imgur.com/EB8ozwT.png"
            $.post('http://banner/save_data', JSON.stringify({
                banner: bannerUrl
            }));
        }
    }
}

function settingsbutton() {
	var x = document.getElementById("settingsz");
	if (x.style.display === "block") {
	  x.style.display = "none";
	} else {
	  x.style.display = "block";
	}
  }

  
function specfans() {
	console.log('klik')
  }