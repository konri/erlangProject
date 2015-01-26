  $(document).ready(function() {
                $.ajax({
                    url: "getAllStatus.yaws",
                    dataType: "text",
                    success: function(data) {
                         var json = $.parseJSON(data);

                        console.log("length oo " + json.data.length + " name: " + json.data[0].name + "status" + json.data[0].status);

                        for(var i = 0; i < json.data.length; i++){
                            var name = json.data[i].name;
                            var rows = json.data[i].status.split("=");

                            var mainTable = '<tr>';
                            mainTable += '<th rowspan=' + rows.length + '>' + name + '</th>';

                            //extract data from each record.
                            for(var j = 0; j < rows.length; j++){
                                if(j > 0)
                                    mainTable += '<tr>';

                                var record = rows[j].split(";");
                                var data = record[0];
                                var days = record[1].split(",");
                                var temp = record[2].split(",");
                                var wind = record[3].split(",");

                                //add data to table
                                mainTable += '<td>' + data + '</td>';


                                //generate new table with dataresources
                                var tableHistory = '';
                                for(var days_i = 0; days_i < days.length; days_i++)
                                    tableHistory += '|' + days[days_i] +'|';
                                tableHistory += '<br />';

                                for(var temp_i = 0; temp_i < temp.length; temp_i++)
                                    tableHistory += '|' + Math.round(parseInt(temp[temp_i]) * 100) / 100 +'|';
                                tableHistory += '<br />';

                                for(var wind_i = 0; wind_i < wind.length; wind_i++)
                                    tableHistory += '|' + Math.round(parseInt(wind[wind_i]) * 100) / 100 +'|';
                                tableHistory += '<br />';



                                mainTable += '<td>' + tableHistory + '</td>';

                                mainTable += '</tr>';
                            }

                            $('#history tr:last').after(mainTable);
                        }

                    }
                });

        });