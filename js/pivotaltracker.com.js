/* dotjs for Pivotal Tracker
 *
 * I like to be able to cmd+enter to submit forms, so I added a simple
 * implementation of this. Pivotal fires a document.ready before the
 * project interface is loaded, so I need to search for editors until
 * they're loaded.
 */

console.log('~/.js/pivotaltracker.com.js loaded');

var editors = [],
    editorSearch,
    bindEditors;

editorSearch = setInterval(function() {
  if(editors.length == 0) {
    editors = $('textarea.editor')
  } else {
    bindEditors();
    clearInterval(editorSearch);
  }
}, 1000);

bindEditors = function() {
  editors.bind('keypress', function(e) {
    if(e.metaKey && (e.keyCode || e.which) == 13) {
      id = this.id.replace('text', 'button')
      add = $('#'+id);
      add.click();
    }
  });
};
