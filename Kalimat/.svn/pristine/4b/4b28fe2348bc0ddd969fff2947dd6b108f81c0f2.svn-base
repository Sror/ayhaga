// We're using a global variable to store the number of occurrences
var MyApp_SearchResultCount = 0;

var console = "\n";
var results = "";

var neighSize = 40;

// helper function, recursively searches in elements and their child nodes
function MyApp_HighlightAllOccurencesOfStringForElement(element,keyword) {
    
    var indexMatchesArray=new Array();
    if (element) {
        if (element.nodeType == 3) {// Text node
            
                var value = element.nodeValue;
                alert("start");
                var symbols="!$%^&*()_+|~-=`{}[]:\";'<>?,./،،:»« ";
                var regexp = new RegExp( keyword, "g")
                var match;
                
                while ((match = regexp.exec(value)) != null) {
                    indexMatchesArray.push(match.index);
                    
                }
                alert(indexMatchesArray);
                
        }else if (element.nodeType == 1) { // Element node
            if (element.style.display != "none" && element.nodeName.toLowerCase() != 'select') {
                for (var i=element.childNodes.length-1; i>=0; i--) {
                    var value = element.childNodes[i].nodeValue;
                    var idx = value.toLowerCase().indexOf(keyword);
                    if(idx < 0){
                        continue;
                    }
                    MyApp_HighlightAllOccurencesOfStringForElement(element.childNodes[i],keyword);
                }
            }
        }
    }
  }


function getPos(el) {
    // yay readability
    for (var lx=0, ly=0; el != null; lx += el.offsetLeft, ly += el.offsetTop, el = el.offsetParent);
    return {x: lx,y: ly};
}

// the main entry point to start the search
function MyApp_HighlightAllOccurencesOfString(keyword) {

    MyApp_RemoveAllHighlights();
    alert(document.body.childNodes.length);
    for (var i=document.body.childNodes.length-1; i>=0; i--) {
        MyApp_HighlightAllOccurencesOfStringForElement(document.body.childNodes[i],keyword);
    }
    //MyApp_HighlightAllOccurencesOfStringForElement(document.body, keyword.toLowerCase());
}

// helper function, recursively removes the highlights in elements and their childs
function MyApp_RemoveAllHighlightsForElement(element) {
    if (element) {
        if (element.nodeType == 1) {
            if (element.getAttribute("class") == "highlight") {
                var text = element.removeChild(element.firstChild);
                element.parentNode.insertBefore(text,element);
                element.parentNode.removeChild(element);
                return true;
            } else {
                var normalize = false;
                for (var i=element.childNodes.length-1; i>=0; i--) {
                    if (MyApp_RemoveAllHighlightsForElement(element.childNodes[i])) {
                        normalize = true;
                    }
                }
                if (normalize) {
                    element.normalize();
                }
            }
        }
    }
    return false;
}

// the main entry point to remove the highlights
function MyApp_RemoveAllHighlights() {
    MyApp_SearchResultCount = 0;
    MyApp_RemoveAllHighlightsForElement(document.body);
}