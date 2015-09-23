(function ( $, window, document, undefined ) {
    
    var $ = jQuery.noConflict();

    // Search Facets
    $('div.facet .department ul').each(function() {
        $(this).children('li:gt(' + (FB.displayeddepartment - 1) + ')').hide();
    });

    // Search Facets
    $('div.facet .index ul').each(function() {
        $(this).children('li:gt(' + (FB.displayedIndex - 1) + ')').hide();
    });

    //Clear Selected Facets
    $('#clearFacets').on("click",function(e) {
        if($("#clearFacets").is(":checked")) {
                $("#facetScope").val("");
        }
        $('#search-form-query form').submit();
        });

    //Check if index has been selected and set checkbox to true
    $(document).ready(function(){

        if(jQuery('#facetScope').length < 1){

        }else{
            var value = jQuery('#facetScope').attr('value');
            var getlabel = value.match(/=[a-z]/g);
            $.each( getlabel, function( index, value ){
                var replabel=value.replace('=','#');
                $('input'+replabel).prop('checked',true);

            });      
        }


    });
    

})( $, window, document );  