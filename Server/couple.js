var Couple = {
	readJson: function() {
        $.getJSON('coupleData.json', function(json) {
            if(json.config.coupled == true) {
                $('body').addClass('coupled');
                $('body').removeClass('notcoupled');
                
                
//                 { "config" : { "coupled" : true, "settings" : { "phoneid" : "1234567890", "uuid" : "1234-5678-0987-6543", "major" : "12345", "minor" : "54321" } }}
                
                
                statusmessage = "Phone Id <strong>" + json.config.settings.phoneid + "</strong>";
                statusmessage += "<br>UUID <strong>" + json.config.settings.uuid + "</strong>";
                statusmessage += "<br>Major <strong>" + json.config.settings.major + "</strong>";
                statusmessage += "<br>Minor <strong>" + json.config.settings.minor + "</strong>";
                
                $('#status').text('Coupled');
                $('#status_message').html(statusmessage);
            } else {
                $('body').addClass('notcoupled');
                $('body').removeClass('coupled');
                
                $('#status').text('Not coupled');
                $('#status_message').text('Waiting for Beacon...');
            }
        });
	}
};

$(document).ready(function() {
	setInterval(function() { Couple.readJson(); }, 500);
//    
//    var config = { "config" : { "coupled" : false, "settings" : "" }};
//
//    console.log(config);
});