// We're using a global variable to store the number of occurrences
var MyApp_SearchResultCount = 0;

var console = "\n";
var results = "";

var neighSize = 40;

// helper function, recursively searches in elements and their child nodes
function MyApp_HighlightAllOccurencesOfStringForElement(element,keyword) {
    
    if (element) {
        if (element.nodeType == 3) {// Text node
            while (true) {
                
                var value = element.nodeValue;  // Search for keyword in text node
                //
                var symbols="!$%^&*()_+|~-=`{}[]:\";'<>?,./،،:»« ";
                var idx = value.toLowerCase().indexOf(keyword);
                // alert(value.charAt(idx-1));
                // alert(idx);
                if(idx < 0){
                    break;
                }
                idx++;
                var span = document.createElement("span");
                span.className = "highlight";
                var text = document.createTextNode(value.substr(idx,keyword.length-2));
                // alert(value.substr(idx,keyword.length-1)+"11");
                span.appendChild(text);
                
                var rightText = document.createTextNode(value.substr(idx+keyword.length-2));
                element.deleteData(idx, value.length - idx);
                
                var next = element.nextSibling;
                element.parentNode.insertBefore(rightText, next);
                element.parentNode.insertBefore(span, rightText);
                
                var leftNeighText = element.nodeValue.substr(element.length - neighSize, neighSize);
                var rightNeighText = rightText.nodeValue.substr(0, neighSize);
                
                element = rightText;
                
                MyApp_SearchResultCount++;
                
                console += "Span className: " + span.className + "\n";
                console += "Span position: (" + getPos(span).x + ", " + getPos(span).y + ")\n";
                
                leftNeighText=leftNeighText.replace("\n"," ");
                if(leftNeighText.charAt(leftNeighText.length) == " "){
                    leftNeighText=leftNeighText.trim();
                    leftNeighText=leftNeighText+" ";
                }
                //alert("6");
                rightNeighText=rightNeighText.replace("\n"," ");
                if(rightNeighText.charAt(0) == " "){
                    rightNeighText=rightNeighText.trim();
                    rightNeighText=" "+rightNeighText;
                }
                leftNeighText=leftNeighText.substring(leftNeighText.indexOf(" "),leftNeighText.length);
                rightNeighText=rightNeighText.substring(0,rightNeighText.lastIndexOf(" "));
                results += getPos(span).x + "," + getPos(span).y + "," + escape(leftNeighText + text.nodeValue + rightNeighText) + ";";
                
                results;
                
               // alert(idx+","+value.charAt(idx-1)+value.charAt(idx+keyword.length)+ (idx == 0 || symbols.indexOf(value.charAt(idx-1))>0));
               /*
                if(idx == 0 || symbols.indexOf(value.charAt(idx-1))>0){
                  // alert(1);
                   if(idx+keyword.length == value.length || symbols.indexOf(value.charAt(idx+keyword.length))>0){
                       
                      
                  // alert(2);
                     
                   }else{
                      span.innerHTML="";
                       
                   }
                }else
                    span.innerHTML="";
                */
                   
            }
            
        } else if (element.nodeType == 1) { // Element node
            if (element.style.display != "none" && element.nodeName.toLowerCase() != 'select') {
                for (var i=element.childNodes.length-1; i>=0; i--) {
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
    // alert(keyword);
    MyApp_RemoveAllHighlights();
    MyApp_HighlightAllOccurencesOfStringForElement(document.body, keyword.toLowerCase());
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