Course Result
=================
*&lt; __NOTE:__  This should be appended to 3.2. Result types in CLIENT_user_interface_specification_v_latest &gt;*

| ID | Name | Data Source | Description |
| ---| ---- | ----------- | ----------- |
| 1 | Result header information | Sourced from;<ul><li>Course Name</li><li>Course Code</li><li>Course level</li></ul> | The most essential course information to assist a user to identify a course is placed here.<br> The Course Name is truncated at 70 characters |
| 2 | Show/hide extended summary | N/A | <ul><li>On hover of result header the result label 'expand' will appear and the presentation will change to indicate to the user this element is clickable.</li><li>On click of the result header; <ul> <li>The extended summary is displayed to user.</li><li>The result block will be considered in a selected state. The block will use visual cues to imply the selected state.</li><li>The label 'expand' will change to 'close' and will persist while the block is in it's selected state.</li><li>Any currently selected results will deselected and its extended summary will be hidden. Only one result can selected at at time. </li></ul></li></ul> |
| 3 | Summary | Sourced from;<ul><li>Course description</li><li>Query biased summary.</li></ul> | <ul><li>Displays a summary contextual to on the users query known as a query biased summary).</li><li>If a query biased summary is not found then the course description will be displayed.</li><li>Keyword terms from the users query will be visually highlighted within the summary text.</li><li>The summary will be truncated at 255 characters.</li></ul> |
| 4 | Extended summary | Sourced from;<ul><li>Course mode</li><li>Course Campus.</li><li>Course duration</li></ul> | <ul><li>Display the technical attributes of the course such as course mode, campus, duration etc.</li><li>Hidden by default. This is displayed when the results header is clicked.</li></ul> |
| 5 | Collapsed Results | N/A | Collapsed results are enabled, refer to [Collapsed Result Section for further information](COLLAPSED_RESULTS_CONFIGURATION.md). |
| 6 | Footer tools | N/A | Tools in this area are hidden until; <ul><li>A user hovers over the result.</li><li><u>Or</u> selects the result. When a result is selected the footer tools remain viewable.</li></ul> |
| 7 | Result calls to actions and tools | N/A | Displays buttons to; <ul><li>See cached view of the document (This is the content of document at indexing stage).</li><li>Explore, which submits a search to find results similar to this one. See [explore links](#http://docs.funnelback.com/14.2/explore_links.html)</li><li>Add to short list. Adds the course to the user's shortlist. See [shortlist for more details]().</li><li>Expanded view. On click display's result in a modal (popup). See [result modal for more details](#) .</li><li>View course button which redirects the user to the course page.</li></ul> |
| 8 | Share tools | N/A | Allows the user to share the result via email and social media. <br>By default we recommend using the thirdparty tool [addThis](http://www.addthis.com). For this <CLIENT_NAME> is required to signup to an addThis.com account. <br>NOTE: Other third party share tools could be embedded here. |

## Progressive disclosure
Progressive disclosure will be configured as so;

| ID  | Trigger Element / Component  | Event |  Action Element / Component  | Action | Description |
| --- | ---------------------------- | ----- | ---------------------------- | ------ | ----------- |
| 1 	|  Result header |  Default | Result footer | hide | Animates fade out.|
| 1.1 |  Result header |  Hover | Result footer |  show | Animates fade in. |
| 1.1 |  Result header | Selected / Active | Result footer |  show | |
