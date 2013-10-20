(function(){
	document.onselectstart=(function(){ return true; });
	question = $('[action="elanceexamnojsx.asp"] tr[height] table tr + tr td').html();
	type = $('[action="elanceexamnojsx.asp"] tr[height] table:not([cellpadding]) tr td input').attr('type') === 'radio' ? 'single' : 'multiple';
	elements = $('[action="elanceexamnojsx.asp"] tr[height] table:not([cellpadding]) tr'); //.getElementsByTagName('tr');
	answers = [];
	for ( var i=0; i < elements.length; i++ ) { answers[i] = elements[i].getElementsByTagName('td')[2].innerHTML; }
	console.log(question, type);
	console.log(answers);
	string = '<textarea style="width: 100%; min-height: 100px;" id="copy-to-clipboard">'+question+' - '+type+'    ';
	for ( var j=0; j < answers.length; j++ ) { string += "\n * "+answers[j]}
	string += "\n\n</textarea>";
	if ( question && answers.length && type )
		$.ajax('http://elance.dev/capture.php', { data: { question: question, answers: answers, type: type } } );
})()
