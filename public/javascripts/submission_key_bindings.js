jQuery(function() {
  var previous = $('#previous').attr('href');
  var next = $('#next').attr('href');

  $(document).bind('keypress', 'j', next_submission);
  $(document).bind('keypress', 'k', previous_submission);

  function previous_submission()  
  {  
    window.location = previous;  
    return false;  
  };

  function next_submission()  
  {  
    window.location = next;  
    return false;  
  };
});