def q = transaction.question
// Hookscripts for A-Z listings.  Assume:
// - 'lastnameInitial' facet
// - sourced from metadata field '0')
if(q.extraSearch == false){  
    if (q.inputParameterMap["letter"] != null) {
                
          q.query = "!padrenullqueryAZ"
          q.inputParameterMap["sort"] = "metaC"
          
          // Avoid pagination - show 5000 results when browsing A-Z
          q.additionalParameters["num_ranks"] = ["5000"] as List
          
          // Apply facet constraint on selected letter      
          if (q.inputParameterMap["letter"] != "all") {
            q.inputParameterMap["f.LNInitial|C"] = q.inputParameterMap["letter"]
          }
        }
    }
