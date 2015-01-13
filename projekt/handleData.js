function create2DArray(rows) {
    var arr = [];

    for (var i=0;i<rows;i++) {
    arr[i] = [];
    }

    return arr;
    }

function create3DArray(howManySites, howManyDates) {
    var arr = new Array(howManySites);

    // create 2D
    for (i = 0; i < arr.length; i++) {
        arr[i] = new Array(howManyDates);
    }
    // create 3D
    for (i = 0; i < arr.length; i++) {
     for (j = 0; j < arr[0].length; j++) {
      arr[i][j] = new Array(3);
     }
    }
    return arr;
    }


function readCookie(name) {
    var nameEQ = name + "=";
    var ca = document.cookie.split(';');
    for(var i=0;i < ca.length;i++) {
        var c = ca[i];
        while (c.charAt(0)==' ') c = c.substring(1,c.length);
        if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
    }
    return null;
}



function getArray() {

    document.getElementById("demo").innerHTML = "::";
    var getCookie;

    if( (getCookie = readCookie('AllValues')) != null){

        console.log("cookie: " + getCookie);

        var dataSites = getCookie.split("+");
        var getTmpDataLength = ((dataSites[0].split("="))[0].split(",")).length;

        console.log("datasite: " + dataSites[2]);
        console.log("datasite: " + dataSites.length + " -- " + getTmpDataLength);

        var arrayReturn = create3DArray(dataSites.length,(getTmpDataLength+1));

        for(var dataSiteId = 0; dataSiteId < dataSites.length; dataSiteId++){
           var tmpTab = dataSites[dataSiteId].split("=");
           var days  = tmpTab[0].split(",");
           var temps = tmpTab[1].split(",");
           var winds = tmpTab[2].split(",");

             console.log("Days: " + days);
           arrayReturn[dataSiteId][0][0] = 'Day';
           arrayReturn[dataSiteId][0][1] = 'Temp';
           arrayReturn[dataSiteId][0][2] = 'Wind';



            for(var i = 0; i < days.length; i++){
                arrayReturn[dataSiteId][i + 1][0] = days[i];
                arrayReturn[dataSiteId][i + 1][1] = parseInt(temps[i]);
                arrayReturn[dataSiteId][i + 1][2] = parseInt(winds[i]);
            }
    console.log(days.length);


        }
       return arrayReturn;
    }else{
        return null;
    }

}

function getMeanArray(dataSites){
    var meanArray;
    var lengthData = dataSites[0].length;

    console.log("length: " + lengthData);
    meanArray = create2DArray(lengthData);
    meanArray[0][0] = 'Day';
    meanArray[0][1] = 'Temp';
    meanArray[0][2] = 'Wind';

    for(var i = 1; i < lengthData; i++){
    meanArray[i][0] = dataSites[0][i][0];
        var meanTemp = 0;
        var meanWind = 0;
        for(var j = 0; j < dataSites.length; j++){
            meanTemp += dataSites[j][i][1];
            meanWind += dataSites[j][i][2];
        }

        meanTemp = meanTemp / dataSites.length;
        meanWind = meanWind / dataSites.length;
        meanArray[i][1] = meanTemp;
        meanArray[i][2] = meanWind;
    }
    return meanArray;

}

function myFunction(){
     var array = getArray();
    console.log("dzia" + array[0].length);
    var i,j,k;
               for(i = 0; i < array.length; i++){
                   for(j = 0; j < array[0].length; j++){
                        for(k = 0; k < array[0][0].length; k++){
                            document.getElementById("demo").innerHTML += array[i][j][k] + "|";

                        }
                    document.getElementById("demo").innerHTML += "<br />";

                    }
                    document.getElementById("demo").innerHTML += "<br />****************<br />";
                }


}






google.setOnLoadCallback(drawChart);

      function drawChart() {
      var dataFromWebsites;
      if( (dataFromWebsites = getArray()) != null){
      var i;
            for(i = 0; i < dataFromWebsites.length; i++){

                    var iDiv = document.createElement('div');
                    iDiv.id = 'block'+i;
                    iDiv.className = 'block';
                    document.getElementsByTagName('body')[0].appendChild(iDiv);
                    var data = google.visualization.arrayToDataTable(dataFromWebsites[i]);

                    var options = {
                      title: 'Pogoda nr: ' + i ,
                      curveType: 'function',
                      legend: { position: 'bottom' }
                    };

                    var chart = new google.visualization.LineChart(document.getElementById('block'+i));

                    chart.draw(data, options);
      }

            var meanArray = getMeanArray(dataFromWebsites);
            var iDiv = document.createElement('div');
                                iDiv.id = 'block'+(i+1);
                                iDiv.className = 'block';
                                document.getElementsByTagName('body')[0].appendChild(iDiv);
                                var data = google.visualization.arrayToDataTable(meanArray);

                                var options = {
                                  title: 'Srednie wartosci',
                                  curveType: 'function',
                                  legend: { position: 'bottom' }
                                };

                                var chart = new google.visualization.LineChart(document.getElementById('block'+(i+1)));

                                chart.draw(data, options);




        }








      }
