/*
 * Copyright (c) 2011-2013 BlackBerry Limited.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import bb.cascades 1.2

Page {
    Container {
        ListView {
            id: m_listView
            objectName: "m_listView"
            dataModel: dataModel1
            
            listItemComponents: ListItemComponent {
                type: "item"
                Container {
                    layout: StackLayout {orientation: LayoutOrientation.TopToBottom}
                    Label {
                        text: ListItemData.fixtureInfo
                    }
                    Label {
                        text: ListItemData.stadiumInfo
                    }
                    Label {
                        text: ListItemData.dateInfo
                    }
                    Label {
                        text: ListItemData.timeInfo
                    }
                    Divider {}
                }
            }
        }
        attachedObjects: [
            // Definition of the second Page, used to dynamically create the Page above.
            GroupDataModel {
                id: dataModel1
                sortingKeys: [ "dateNumber", "id" ]
                grouping: ItemGrouping.ByFullValue
            },
            DataSource {
                id: dateTimePickerDataSource
                property string sQuery: ""
                onSQueryChanged: {
                    dataModel1.clear()
                    load()
                }
                source: "asset:///JSON/Fixtures.json"
                type: DataSourceType.Json
                remote: false
                
                onDataLoaded: {
                    //create a temporary array tohold the data
                    var tempdata = new Array();
                    for (var i = 0; i < data.length; i ++) {
                        
                        tempdata[i] = data[i]
                        
                        //this is where we handle the search query
                        if (sQuery == "") {
                            //if no query is made, we load all the data
                            dataModel1.insert(tempdata[i])
                        } else {
                            //if the query matches any part of the country TITLE, we insert that into the list
                            //we use a regExp to compare the search query to the COUNTRY TITLE (case insenstive)
                            if (data[i].dateNumber.search(new RegExp(sQuery, "i")) != -1) {
                                dataModel1.insert(tempdata[i])
                                
                                //Otherwise, we do nothingand donot insert the item
                            }
                        
                        }
                    
                    }
                    
                    // this if statement below does the same as above,but handles the output if there is only one search result
                    if (tempdata[0] == undefined) {
                        tempdata = data
                        
                        if (sQuery == "") {
                            dataModel1.insert(tempdata)
                        } else {
                            if (data.dateNumber.search(new RegExp(sQuery, "i")) != -1) {
                                dataModel1.insert(tempdata)
                            }
                        }
                    }
                }
                onError: {
                    console.log(errorMessage)
                }
            }
        ]
    }
}
