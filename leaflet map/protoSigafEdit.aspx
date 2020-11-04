<!--%@ Page Language="C#"  EnableViewState="true" AutoEventWireup="true"  Inherits="MSDN.SessionPage"%-->
<!--%@ Page Language="C#"  EnableViewState="true" AutoEventWireup="true" CodeBehind="protoSigafEdit.aspx.cs" Inherits="leaflet_map.getLocalHostAddr, MSDN.SessionPage"%-->
<%@ Page Language="C#"  EnableViewState="true" AutoEventWireup="true" CodeBehind="protoSigafEdit.aspx.cs" Inherits="leaflet_map.getLocalHostAddr"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <title>Catasto WMS con Leaflet</title>

    <meta name="viewport" content="initial-scale=1.0, user-scalable=no, width=device-width">

    <link rel="stylesheet" href="http://cdn.leafletjs.com/leaflet/v1.3.4/leaflet.css" />
    <link rel="stylesheet" href="dist/leaflet.pm.css" />

    <script src="http://cdn.leafletjs.com/leaflet/v1.3.4/leaflet.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/proj4js/2.5.0/proj4.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/proj4leaflet/1.0.2/proj4leaflet.js"></script>
    <script src="dist/leaflet-wfst.src.js"></script>
    <script src="dist/leaflet.pm.min.js"></script>

    <script type="module" >

        import * as objTest from './test/testLeafletMap.js';
        
        // -- separate scope from global scope

        (function () {

            // -- map extents and center

            var toscExtents3003 = [
                    [1554746.1124763484, 4686710.11317738],
                    [1771653.1243634056, 4924787.538759868]
                ],                                                  // tuscany region extents in EPSG:3003 SRS
                toscCenter3003 = [
                    (toscExtents3003[1][0] + toscExtents3003[0][0]) / 2.0,
                    (toscExtents3003[1][1] + toscExtents3003[0][1]) / 2.0
                ],                                                  // tuscany region extents center in EPSG:3003 SRS
                toscExtents = [
                    [42.155259, 9.398804],
                    [44.523927, 12.650757]],
                toscCenter = [
                    (toscExtents[1][0] + toscExtents[0][0]) / 2.0,
                    (toscExtents[1][1] + toscExtents[0][1]) / 2.0
                ],

            // -- builds object {"ipAddress": "server_ip_addr_value","location": "internet|intranet"}

                serverAddrAndType = <%=leaflet_map.getLocalHostAddr.serverAddrAndType%>;

            //function print(s){
            //    var to = document.getElementById('messages'),
            //        prevString=to.nodeName=='PRE'? to.textContent:to.innerHTML,
            //        len=null,
            //        ending = '',
            //        arg=null;
            //    for (var k =1;k<arguments.length;k++) {
            //        arg=arguments[k];
            //        if (arg == 'replace') prevString = '';
            //        else if (arg.startsWith('first')) {
            //            len = isNaN(arg.substr(6)) ? null: parseInt(arg.substr(6));
            //            s=s.substr(0,len) + '...';
            //        } 
            //        else if (arg.endsWith('$')) ending= arg.substr(0,arg.length-1);
            //    }       

            //    if (!!to) {
            //        if(to.nodeName=='PRE') 
            //            to.textContent = prevString + s + ending;
            //        else
            //            to.innerHTML = prevString + s + ending;
            //    }
            //}

            function print(s){
                var ending = '',
                    arg=null;
                for (var k =1;k<arguments.length;k++) {
                    arg=arguments[k];
                    if (arg == 'replace') console.clear();
                    else if (arg.startsWith('first')) {
                        if (!isNaN(arg.substr(6))) {
                            len = parseInt(arg.substr(6));
                            s=s.substr(0,len) + '...';
                        }
                    } 
                    else if (arg.endsWith('$')) ending= arg.substr(0,arg.length-1);
                }       
                console.log(s + ending);
            }

            function numProperties(obj) {
                var kk=0; 
                if (typeof(obj)!="object") return -1;
                for(var k in obj) kk++;
                return kk;
            }

            // -- get date converted into ISO Local Date string (format: AAAA-MM-GGThh:mm:ss.SSSZ - example '2019-10-18T12:45:01.437Z')
            Date.prototype.toISOLocalDateTime = function(){
                    return new Date(new Date(this.valueOf()).getTime() - new Date(this.valueOf()).getTimezoneOffset() * 60000).toISOString();
            }

            // -- JSON.stringify(circularReference, getCircularReplacer());
            const getCircularReplacer = () => {
                const seen = new WeakSet();
                return (key, value) => {
                    if (typeof value === "object" && value !== null) {
                        if (seen.has(value)) {
                            return String(value) +': (circular ref.)';
                        }
                        seen.add(value);
                    }
                    return value;
                };
            };

            function exists(obj) {
                return typeof(obj)!='undefined'
            }

            function colorHexToRgb(hex,transp) {

                // -- converts couple ()hexadecimal color string, float transparency) into RGB(r,g,b,t) format 

                if(!hex.startsWith('#') || hex.length!=7 || isNaN('0x' + hex.substr(-6)) 
                  ) return false;
    
                var s = hex.substr(-6),
                    rgb='RGB(';
                for (var k=0;k<6; k+=2) {
                    rgb+=parseInt('0x'+s.substr(k,2)) + ','
                }
                return rgb + transp.toString(10) +')'
            }


            window.addEventListener("load", initMap);

            function initMap() {

                /***
                * initMap function: last level of closure
                * ----------------  --------------------
                * activatewd when document is loaded.
                *
                * Put here all code and data wich must be activated only
                * when html dom document is completely loaded. 
                *
                * put here tests of new function defined at first level of closure (self infoking first level function)
                *
                ***/

                // -- debugging tests.

                objTest.getServerData(serverAddrAndType);

                objTest.getMapBounds(toscCenter,toscCenter3003,toscExtents,toscExtents3003);

                //console.log ('new Date().toISOLocalDateTime() = ',new Date().toISOLocalDateTime());
                //var d= new Date(2014,9,14,14,12,25,156);
                //console.log('d = ', d);
                //console.log('d.toISOLocalDateTime() = ', d.toISOLocalDateTime());

                objTest.checkISOLocalDateTime();

                // -- builds url of ARTEA GeoServer 

                var urlGeoServerArtea = serverAddrAndType.location=="intranet" ? "http://192.168.60.21:8080/geoserver" : "http://159.213.81.199/geoserver",

                    pathArteaWMS =      "/ARTEA/wms",
                    pathArteaTms =      "/gwc/service/tms/1.0.0",
                    pathArteaWFS =      "/wfs",
                    pathArteaWFST =     "/ARTEA/ows",

                    //wfsGetFeatureParameters = { // -- not used
                    //    service: 'WFS',
                    //    version: '1.0.0',
                    //    request: 'GetFeature',
                    //    typeName: 'ARTEA:TOSC_Comuni',
                    //    outputFormat: 'application/json'
                    //},

                    // -- current data from click on a wfst layer

                    currentAdminLimits = {
                        siglaProv: null,
                        descProv: null,
                        comune: null,
                        descComune: null,
                        stringaFoglio: null,
                        foglio:null,
                        part: null
                    },
                    currentLayer = {
                        level: null,
                        layerName:  null,
                        nameSpace: null,
                        name: null,
                        feature: null
                    },

                    editedFeaturesFillColor = colorHexToRgb('#3388ff', 0.2),
                    
                    // -- leaflet.pm status

                    pmStatus = {
                        isActive: false,
                        isDraw: false,
                        isGlobalEdit: false,
                        isDrag: false,
                        isDelete: false,
                        drawType:null,
                        update: function() {
                            this.isActive= this.isDraw || this.isGlobalEdit || this.isDrag ||this.isDelete;
                        },
                        clear: function(){this.isDraw=false; this.isGlobalEdit=false;this.isDrag=false;this.isDelete=false;
                        this.update()}, // -- not used
                        set: function(name,value) {
                            this[name]=value;
                            if (typeof(this[name])=='boolean') {
                                if (value==true)
                                    for (var k in this) if(k!=name && k.startsWith('is')) this[k]=false;
                                this.update();
                            }
                        },
                        toggle: function(name) {
                            this.set(name,!this[name]);
                        },
                        show: function(){ return {isActive:this.isActive,isDraw:this.isDraw,isGlobalEdit: this.isGlobalEdit,isDrag:this.isDrag,drawType:this.drawType,isDelete:this.isDelete}}
                    },

                    // -- all Leaflet Layers object

                    allLayers = null,

                // -- builds GeoServer services request urls

                urlGeoServerArteaWMS =  urlGeoServerArtea + pathArteaWMS,
                urlGeoServerArteaTms =  urlGeoServerArtea + pathArteaTms,
                //urlGeoServerWFS =       urlGeoServerArtea + pathArteaWFS +
                //                        L.Util.getParamString(wfsGetFeatureParameters), // not used
                urlGeoServerWFST =      urlGeoServerArtea + pathArteaWFST;

                //$.ajax({
                //    url: urlGeoServerWFS,
                //    success: function (data) {
                //        var geojson = new L.geoJson(data, {
                //            style: { "color": "#2ECCFA", "weight": 2 },
                //            onEachFeature: function (feature, layer) {
                //                layer.bindPopup("click su " + JSON.stringify(feature.properties));
                //            }
                //        }
                //        ).addTo(map);
                //    }
                //});

                //-- clear debug box text contents pressing on button "clear messages"

                document.getElementById("clearMessages").addEventListener('click', function(){
                    console.clear()
                })
                document.getElementById("showEditedFeatures").addEventListener('click', function(){
                    console.log('editedFeatures=',editedFeatures)
                })
                document.getElementById("updateEditedFeatures").addEventListener('click', updateEditedFeatures);
                document.getElementById("showWorkingLayer").addEventListener('click', function(){
                    console.log('workingLayer=',workingLayer)
                })
                document.getElementById("showObjLayers").addEventListener('click', function(){
                    console.log('objLayers.allLayers=',objLayers.allLayers)
                })
                document.getElementById("showAllLayers").addEventListener('click', function(){
                    console.log('allLayers (all map connected layers)=',allLayers)
                })
                
                //-- add CRS Gauss Boaga west fuse using proj4Leaflet library

                L.CRS.EPSG3003 = new L.Proj.CRS(
                    "EPSG:3003",
                    "+proj=tmerc +lat_0=0 +lon_0=9 +k=0.9996 +x_0=1500000 +y_0=0 +ellps=intl +towgs84=-104.1,-49.1,-9.9,0.971,-2.917,0.714,-11.68 +units=m +no_defs",
                    {}
                );

                // -- build map into tag with id "map"

                var map =
                L.map('map', {
                    center: toscCenter,
                    zoom: 8,
                    minZoom: 8,
                    maxZoom:21
                });

                // -- fit Tuscany region extents bounds scale to cover all the map

                map.fitBounds(toscExtents);

                // -- buid a test point now with bottom,left corner at the top,right corner of tuscany extents and 0.1 m x 0.1 m size

                var testLatLngMin = L.CRS.EPSG3003.unproject({ x: toscExtents3003[1][0], y: toscExtents3003[1][1] }),
                    testLatLngMax = L.CRS.EPSG3003.unproject({ x: toscExtents3003[1][0] + 0.1, y: toscExtents3003[1][1] + 0.1 });


                /*-- create object with:
                        aLayers:                         property returns
                            array [
                              {tiled_LayerName1:objtiledLayer1,wfst_LayerName1:objTiledLayer1,minZoom:number, maxZoom:number},
                              {tiled_LayerName2:objTiledLayer2,wfst_LayerName2:objTiledLayer2,minZoom:number, maxZoom:number},
                              ...,
                              {tiled_LayerNameN:objTiledLayerN,wfst_LayerNameN:objTiledLayerN,minZoom:number, maxZoom:number}
                            ] 
                            with tile layers contained in properties with name prefixed with "tile" 
                            and wfst layers contained in properties with name equal to geoServer layer name prefixed with "wfst", 
                            (layer level is the index of the array element).
                            note that minZom and maxZoom for wfst layers are now setted to be be the same of that od tile layer of the same level
                            ,
                        getLayersByName(name):           method returns object with layer level and the entire layers object at that level wich contains layer with name equal to name par.,
                        getLayerByName(name):            method returns object with layer level and layer object with name=param.,
                        getLevelByLayerName(name):       method returns level of layer object with name=param.,
                        getLayersByLevel(level):         method returns entire layers object at that level,
                        getLayerNamesByType(type,order): method returns array with levels wnd corresponding layer objects with name prefixed with type par. string.
                                                         The objects are orderer corresponding fo tre order string param. wich contains ("desc"|"asc"),
                        maxLevel:                        property return max layer level number (level begins with 0 as the most bottom.
                ---------------------------------------------*/

                var objLayers = {
                    aLayers: [
                        { 'shortName': 'Comuni',         'isEdit': false, 'tiled_Comuni': null,        'wfst_TOSC_Comuni': null,                  'minZoom': null, 'maxZoom': null },
                        { 'shortName': 'Fogli',          'isEdit': false, 'tiled_Fogli': null,         'wfst_TOSC_BordiFoglio': null,             'minZoom': null, 'maxZoom': null },
                        { 'shortName': 'Particelle',     'isEdit': true,  'tiled_Particelle': null,    'wfst_TOSC_Particelle': null,              'minZoom': null, 'maxZoom': null },
                        { 'shortName': 'Poligoni SIGAF', 'isEdit': true,  'tiled_PoligoniSigaf': null, 'wfst_SIGAF_Vista_Poligoni_Attuali': null, 'minZoom': null, 'maxZoom': null }
                    ],

                    _scanLayersandDo: function(methodName, name) {
                        var allLayers={},
                            layerName= null;
                        for (var k=0;k < this.aLayers.length; k++) {
                            for (var kk in this.aLayers[k]) {
                                if (kk == name || name == null) {
                                    switch(methodName) {
                                        case 'getLayersByName':
                                            return {level:k, layers: this.aLayers[k]};
                                            break;
                                        case 'getLayerByName':
                                            return { level: k, layer: this.aLayers[k][kk], minZoom: this.aLayers[k].minZoom, maxZoom: this.aLayers[k].maxZoom};
                                            break;
                                        case 'getLevelByLayerName':
                                            return k;
                                            break;
                                        case 'getAllLayers':
                                            if(this.aLayers[k][kk]!=null) {
                                                if (['tiled','wfst'].indexOf(kk.substr(0,kk.indexOf('_')))>=0) {
                                                    nameLayer=kk;
                                                    allLayers[this.aLayers[k][nameLayer]['_leaflet_id']] =this.aLayers[k][kk];
                                                }
                                            }
                                    }
                                }
                            }
                        }
                        return allLayers
                    },
                    getAllLayers: function() {return this._scanLayersandDo("getAllLayers",null)},
                    getLayersByName: function(name) {return this._scanLayersandDo("getLayersByName",name)},
                    getLayerByName: function (name) {return this._scanLayersandDo("getLayerByName",name)},
                    getLevelByLayerName: function (name) {return this._scanLayersandDo("getLevelByLayerName",name)},
                    getLayersByLevel: function (level) {return this.aLayers[level]},
                    getLayerNamesByType: function(type,order,isEdit) {
                        if (["tiled","wfst","short"].indexOf(type)<0) return [];
                        if (["asc","desc"].indexOf(order)<0) return [];

                        function _addArrayEls(){
                            var layerName ='';
                            for (var kk in this.aLayers[k]) {
                                if (kk.startsWith(type)) {
                                    if (type=='short') {
                                        switch (isEdit){
                                            case true:
                                                layerName = this.aLayers[k]['isEdit'] ? this.aLayers[k]['shortName']: null;
                                                break;
                                            case false:
                                                layerName = !this.aLayers[k]['isEdit'] ? this.aLayers[k]['shortName']: null;
                                                break;
                                            case null:
                                                layerName = this.aLayers[k]['shortName'];
                                        }
                                        tmpObj['layerName']=layerName;
                                    }
                                    if (type=='tiled'){
                                        tmpObj['layerName']= kk;
                                    }
                                    if (type=='wfst'){
                                        tmpObj['layerName']= kk;
                                    }
                                    tmpObj['level']=k;
                                } else {
                                    if(type=='short' && kk.startsWith('tiled')) {
                                        tmpObj['tiled']= kk;
                                    }
                                    if (type=='short' && kk.startsWith('wfst')){
                                        tmpObj['wfst']= kk;
                                    }
                                }
                            }
                            if(layerName!= null) {
                                if (type=='short')
                                    aNames.push(tmpObj);
                                else
                                    aNames.push(tmpObj);
                            }
                            tmpObj={};
                        }

                        var aNames= [],
                            tmpObj={};
                        switch (order) {
                            case "desc":
                                for (var k = this.aLayers.length-1; k >=0 ; k--) {
                                    _addArrayEls.call(this);
                                }
                                break;
                            case "asc":
                                for (var k = 0; k <this.aLayers.length ; k++) {
                                    _addArrayEls.call(this);
                                }
                        }
                        return aNames;
                    }
                };
                Object.defineProperty(objLayers, "maxLevel", {
                    get: function () { return this.aLayers.length - 1 }
                });

                // -- tests objLayers.getLayerNamesByType()

                objTest.checkGetLayerNamesByType(objLayers);
                
                // -- raster backgrounds layers

                //ARTEA:rt_ofc.5k16.32bit
                var ortofoto2016 = L.tileLayer(urlGeoServerArteaTms + "/ARTEA:rt_ofc.5k16.32bit@EPSG:900913@jpeg/{z}/{x}/{-y}.jpeg", {
                    map: 'owsofc',
                    layers: ['rt_ofc.5k16.32bit'],
                    minZoom: 16,
                    maxZoom: 21,
                    tms: true,
                    crs: L.CRS.EPSG3003,
                    attribution: 'AGEA|OFC 2016 5k',
                    transparent: true,
                    //updateWhenIdle: true
                }).addTo(map);

                allLayers= ortofoto2016._map._layers;

                //mapBox OSM Satellite
                var mapboxOrtofoto = L.tileLayer('https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token={accessToken}', {
                    attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="http://mapbox.com">Mapbox</a>',
                    minZoom: 14,
                    maxZoom: 21,
                    id: 'mapbox.satellite',
                    accessToken: 'pk.eyJ1IjoiemxlZDU1IiwiYSI6ImNqdGxnMWVwbjA3dTE0OW9qNmhibjF1aDEifQ.xdbVsuJslfBtPai_Na04vw',
                    //updateWhenIdle: true
                }).addTo(map);

                //google Maps Satellite
                var googleMap = L.tileLayer('http://www.google.cn/maps/vt?lyrs=s@189&gl=cn&x={x}&y={y}&z={z}', {
                    attribution: 'google',
                    minZoom: 14,
                    maxZoom: 21,
                    //updateWhenIdle: true
                }).addTo(map);

                //OSM map
                var OSM_basemap = L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png', {
                    attribution: '&copy; <a href="http://osm.org/copyright" target="_blank">OpenStreetMap</a>',
                    minZoom: 8,
                    maxZoom: 21
                }).addTo(map);

                //-- tiled layers from vector geometric features table

                objLayers.aLayers[0].tiled_Comuni = L.tileLayer(urlGeoServerArteaTms + "/ARTEA:TOSC_Comuni@EPSG:900913@png/{z}/{x}/{-y}.png", {
                    layers: ['ARTEA:TOSC_Comuni'],
                    minZoom: 8,
                    maxZoom: 12,
                    tms: true,
                    crs: L.CRS.EPSG3003,
                    attribution: false,
                    transparent: true,
                    updateWhenIdle: true
                }).addTo(map);
                objLayers.aLayers[0].minZoom = objLayers.aLayers[0].tiled_Comuni.options.minZoom;
                objLayers.aLayers[0].maxZoom = objLayers.aLayers[0].tiled_Comuni.options.maxZoom;

                objLayers.aLayers[1].tiled_Fogli = L.tileLayer(urlGeoServerArteaTms + "/ARTEA:TOSC_BordiFoglio@EPSG:900913@png/{z}/{x}/{-y}.png", {
                    layers: ['ARTEA:TOSC_BordiFoglio'],
                    minZoom: 14,
                    maxZoom: 15,
                    tms: true,
                    crs: L.CRS.EPSG3003,
                    //updateWhenIdle: true
                }).addTo(map);
                objLayers.aLayers[1].minZoom = objLayers.aLayers[1].tiled_Fogli.options.minZoom;
                objLayers.aLayers[1].maxZoom = objLayers.aLayers[1].tiled_Fogli.options.maxZoom;

                // -- by now this layer does not work in wfst (it's an sql view with union 
                //    and must be substituted with a layer group).

                objLayers.aLayers[2].tiled_Particelle = L.tileLayer(urlGeoServerArteaTms + "/ARTEA:TOSC_Particelle@EPSG:900913@png/{z}/{x}/{-y}.png", {
                    layers: ['ARTEA:TOSC_Particelle'],
                    minZoom: 17,
                    maxZoom: 21,
                    tms: true,
                    crs: L.CRS.EPSG3003,
                    updateWhenIdle: true
                }).addTo(map);
                objLayers.aLayers[2].minZoom = objLayers.aLayers[2].tiled_Particelle.options.minZoom;
                objLayers.aLayers[2].maxZoom = objLayers.aLayers[2].tiled_Particelle.options.maxZoom;

                objLayers.aLayers[3].tiled_PoligoniSigaf = L.tileLayer(urlGeoServerArteaTms + "/ARTEA:SIGAF_Vista_Poligoni_Attuali@EPSG:900913@png/{z}/{x}/{-y}.png", {
                    layers: ['ARTEA:SIGAF_Vista_Poligoni_Attuali'],
                    minZoom: 16,
                    maxZoom: 21,
                    tms: true,
                    crs: L.CRS.EPSG3003,
                    updateWhenIdle: true
                }).addTo(map);
                objLayers.aLayers[3].minZoom = objLayers.aLayers[3].tiled_PoligoniSigaf.options.minZoom;
                objLayers.aLayers[3].maxZoom = objLayers.aLayers[3].tiled_PoligoniSigaf.options.maxZoom;

                var wfstUtil= {
                    _localData: {
                        clickLatLng: null,
                        numSelected: null
                    },
                    getTemplateWfst: function() {
                        // -- template object with wfst layer options and wfst filter. wfst filter is inserted into wst layers options filter property when layer is builded.
                        var objWfst={
                            options: {
                                url: urlGeoServerWFST,
                                maxZoom: 12,
                                typeNS: '',
                                typeName: '',
                                crs: L.CRS.EPSG3003,//L.CRS.EPSG900913,
                                maxFeatures: 1,
                                geometryField: 'geom',
                                filter: null,
                                style: {
                                    stroke: true,
                                    color: 'rgb(256,128,0)',
                                    opacity:1.0,
                                    fill:false,
                                    weight: 3
                                }
                            },
                            filter: new L.Filter.BBox('geom', L.latLngBounds(testLatLngMin, testLatLngMax), L.CRS.EPSG3003)
                        };
                        return objWfst;
                    },
                    wfstLayerCreate: function (reset, objOptions, objFilter, currentZoom, minZoom, maxZoom, nameSpace, layerName, /*tiledLayerName,*/ objLayers, clickLatLng) {

                        // --  create a wfst layer from options object and filter object 
                        //     only if currentZoom between minZoom and maxZoom 
                        //     of current level of required layer.
                    
                        if (currentZoom > maxZoom || currentZoom < minZoom) return null;
                        objOptions.filter = objFilter;
                        objOptions.minZoom = minZoom;
                        objOptions.maxZoom = maxZoom;
                        objOptions.typeNS = nameSpace;
                        objOptions.typeName = layerName;
                        
                        this._localData.clickLatLng=clickLatLng;

                        this._localData.thisLayerLevel = objLayers.getLevelByLayerName('wfst_' + layerName); 
                        //it was objLayers.aLayers.push({}) -1;
                        if(!!reset) this._localData.numSelected = 0;

                        var thisLayer = new L.WFST(objOptions, new L.Format.GeoJSON({ crs: L.CRS.EPSG3003 })).on('load',wfstLoad); //crs: L.CRS.EPSG3003 crs: L.CRS.EPSG900913
                        return thisLayer
                    }
                };

                function wfstLoad(e) {
                    var loadedFeatures = JSON.parse(e.responseText);

                    if (loadedFeatures.features.length == 0){
                        console.log ('from wfst Layer load event: 0 features loaded');
                        return;
                    }

                    var lName='wfst_' + loadedFeatures.features[0].id.split('.')[0],
                        level=objLayers.getLevelByLayerName(lName),
                        thisLayer=objLayers.aLayers[level][lName],
                        tiledName=null,
                        tiledLayers=objLayers.getLayersByLevel(level),
                        thisTiledLayer= null;

                    for(var k in tiledLayers) if (k.startsWith('tiled')) tiledName=k;
                    thisTiledLayer=objLayers.aLayers[level][tiledName];

                    // -- remember e.target.readFormat.featureType.fieldTypes
                            
                    // -- add to map first identified layer with features found and not disabled from layers control
                        
                    if (loadedFeatures.features.length > 0
                        && wfstUtil._localData.numSelected == 0
                        && exists(thisTiledLayer._map)
                        && thisTiledLayer._map!=null
                        ) {
                        wfstUtil._localData.numSelected+=loadedFeatures.totalFeatures;
                        thisLayer.addTo(map);
                        

                        // -- connect layer click event to wfst created layer
                        thisLayer.on('click', wfstClick);
                        //layerCreated = true;
                                
                        console.log(
                            'from wfst Layer load event:'
                        )

                        // -- add current layer fo editedFeatures
                        if (workingLayer == null) workingLayer = e.target.pm._layers[0];
                        if (numProperties(workingLayer._renderer._layers) > 0)
                            editedFeatures = getEditedFeatures(workingLayer, editedFeatures, null);

                        // -- in editing fills wfst features for making them identifyable
                        if(numProperties(editedFeatures)>1 || pmStatus.isActive) {
                            editingFeaturesFill(thisLayer, editedFeaturesFillColor);
                        }
                                

                        // -- set modified property to false for all features 
                        //    contained in loadedFeature feature group  

                        //for (var kkk in e.target._layers) e.target._layers[kkk].modified=false;
                        //editedFeatures={};


                        // -- update array of identified features id

                        aEventPath.push(loadedFeatures.features[0].id);

                        // -- update currentLayer and CurrentAdminLimits data

                        updateCurrentStatus(loadedFeatures.features[0], e.target.options);

                        // -- builds wfst requests filters based on currentLayer, CurrentAdminLimits 
                        //    and current feature data

                        buildWfstFilters(loadedFeatures.features[0]);

                        // -- shows identified feature properties popup

                        showAttributes(loadedFeatures.features[0], wfstUtil._localData.clickLatLng)

                    }
                    console.log(
                        'loaded layer data:', 
                        {
                            layer_Level:level,
                            layeType_And_Name:lName,
                            features_number: (exists(thisLayer._map) 
                                && exists(thisLayer._map._renderer)
                                && exists(thisLayer._map._renderer._layers) ? numProperties(thisLayer._map._renderer._layers):null),
                            srsName: thisLayer.options.srsName,
                            minZoom: thisLayer.options.minZoom,
                            maxZoom: thisLayer.options.maxZoom,
                            style: thisLayer.options.style
                        }
                    );
                }

                //-- builds layers control
            
                var baseMaps = {
                    "ortofoto AGEA 2016": ortofoto2016,
                    "Google": googleMap,
                    "MapBox ortofoto": mapboxOrtofoto,
                    "OpenStreet Map": OSM_basemap,
                };


                /***
                * objLayers.getLayerNamesByType('short','asc',null))):
                * [
                *   {
                *       "level":0,
                *       "layerName":"Comuni",
                *       "tiled":"tiled_Comuni",
                *       "wfst":"wfst_TOSC_Comuni"
                *   },
                *   {
                *       "level":1,
                *       "layerName":"Fogli",
                *       "tiled":"tiled_Fogli",
                *       "wfst":"wfst_TOSC_BordiFoglio"
                *   },
                *   {
                *       "level":2,
                *       "layerName":"Particelle",
                *       "tiled":"tiled_Particelle"
                *   },
                *   {
                *       "level":3,
                *       "layerName":"Poligoni SIGAF",
                *       "tiled":"tiled_PoligoniSigaf",
                *       "wfst":"wfst_SIGAF_Vista_Poligoni_Attuali"
                *   }
                * ]
                ***/

                var aLayerNames = objLayers.getLayerNamesByType('short','asc',null),
                    //olMaps={},
                    overlayMaps= {};

                for (var ol=0; ol<aLayerNames.length;ol++){
                    // -- test ok
                    overlayMaps[aLayerNames[ol]['layerName']] = objLayers.aLayers[ol][aLayerNames[ol]['tiled']]
                }

                var layersControl = L.control.layers(baseMaps, overlayMaps, {
                    collapsed: true
                }).addTo(map);


                // -- build custom control displaying current zoom and scale

                function meterWidthInPixels() {

                    // -- calculate meter width in pixel from temp. div with css width: 100cm

                    var px;
                    var div = document.createElement("div");
                    div.style.cssText = "position: absolute;  left: -100%;  top: -100%;  width: 100cm;";
                    document.body.appendChild(div);
                    var px = div.offsetWidth;
                    document.body.removeChild(div);
                    return px;
                }
                function getScaleFromScaleControl(scaleControl) {

                    // -- calculate scale from scaleControl string measure and pixel width

                    var pxStringWidth = scaleControl._mScale.style.width,
                        widthString = scaleControl._mScale.innerHTML,
                        width = widthString.endsWith("km") ? parseInt(widthString) * 1000 : parseInt(widthString),
                        pxWidth = parseInt(pxStringWidth);
                    return width * meterWidthInPixels()/pxWidth;
                }

                L.Control.zoomAndScaleInfo = L.Control.extend({
                    _zoom: null,
                    _scale: null,
                    _zoomValue: null,
                    _scaleValue: null,
                    setZoomAndScale: function () {
                        // -- event handler for zoomend map event
                        this._zoom = map.getZoom();
                        this._zoomValue.textContent = String(this._zoom);
                        this._scale = (!!scaleControl ? parseInt(getScaleFromScaleControl(scaleControl)) : null);
                        this._scaleValue.textContent = String((this._scale==null ? "":this._scale));
                    },
                    onAdd: function (map) {
                        var div = L.DomUtil.create('div');
                        div.className = 'leaflet-control-scale-line';
                        //div.style.cssText = "width:150px";
                        var aLabels = {
                            _zoomValue: "zoom",
                            _scaleValue: "scala"
                        },
                        d1;
                        for (var k in aLabels) {
                            d1 = L.DomUtil.create("div", "ScaleInfoLabel", div);
                            this[k] = L.DomUtil.create("div", "ScaleInfoValue", div);
                            d1.textContent = aLabels[k];
                            L.DomUtil.create("br", "", div);
                        }
                        this.setZoomAndScale();
                        return div;
                    },
                    
                    onRemove: function (map) {
                        // Nothing to do here
                    }
                });

                // -- build new instance of custom zoomAndScaleInfo control with opts options

                L.control.zoomAndScaleInfo = function (opts) {
                    return new L.Control.zoomAndScaleInfo(opts);
                }

                // -- adds custom zoomAndScaleInfo control to map with opts options

                var zoomAndScaleInfo = L.control.zoomAndScaleInfo({ position: 'bottomleft' }).addTo(map);

                // -- adds scale control to map with with scaleOptions options

                var scaleOptions = { imperial: false };
                var scaleControl = L.control.scale(scaleOptions).addTo(map);

                // -- connect zoomend Leaflet event to event handler

                map.on('zoomend', function (e) {
                    zoomAndScaleInfo.setZoomAndScale();
                })

                scaleControl._container.style.marginLeft = "10px";

                // -- events ---------------------------------------------------------------------------------

                // -- manages click on wfst layer feature for showing feature attributes

                var aEventPath = [],                    // array of identified features id 
                                                        // emptied by map click event handler.
                    popup = L.popup({ maxWidth: 500 }), // popup for identified data



                    // -- wfst requests filters builded by wfst Layer click event handler.
                    // ------------------------------------------------------------------
                    filterFoglio = null,                // filter PropertyIsEqualTo
                    filterComune = null;                // filter And|PropertyIsLike


                function makeDraggable(popup) {
                    var pos = map.latLngToLayerPoint(popup.getLatLng());
                    L.DomUtil.setPosition(popup._wrapper.parentNode, pos);
                    var draggable = new L.Draggable(popup._container, popup._wrapper);
                    draggable.enable();
                }

                function featurePropertyManager (feature, coords) {
                /***
                * Allows to select the layer from which to take the properties (attributes) template.
                * Drawing a new features mantains the last selected template.
                * Predefined attributes values are taken from: 
                *    currentAdminLimits {siglaProv,descProv,comune,descComune,stringaFoglio,foglio,part} 
                *    currentLayer       {level,layerName,nameSpace,name,feature}
                * This popup contains the interface for editing alfanumerical attributes, was  
                * originally builded from showAttributes function, and use Editing data
                * object editedFeatures for get and save editedFeatures[id].feature.property data. 
                * If current feature does not contains values of foglio and part attributes 
                * it is necessary to make an wfst request from TOSC_Comuni, TOSC_BordiFoglio, TOSC_Particelle
                * to get currentAdminLimits correct data.
                *
                * feature: feature object (example e.layer.feature)
                * coords:  where to show popup on map (example e.latlng)
                ***/
                    console.log('featurePropertyManager()30% done ...')

                    // -- create html interface with DOM 
                    
                    var div = L.DomUtil.create('div','AttribInfoDiv'),
                        tAttrib = L.DomUtil.create('table','tAttrib',div),
                        rowAttrib, 
                        col1,
                        col2,
                        divLayers   = L.DomUtil.create("div", 'divLayers',div),
                        divTxtLayers   = L.DomUtil.create("div", 'divTxtLayers',  divLayers),
                        selLayers   = L.DomUtil.create("select", 'selLayers', divLayers),
                        msg = L.DomUtil.create("div", 'editAttribMsg',  divLayers);

                    // -- attribs table body data 

                    for (var k in feature.properties) {
                        rowAttrib = tAttrib.insertRow();
                        col1 = rowAttrib.insertCell();
                        col2 = rowAttrib.insertCell();
                        col1.className='rowAttribInfoLabel colAttrib'
                        col2.className='rowAttribInfoValue colAttrib'
                        rowAttrib.className='rowAttrib';
                        col1.textContent = k;
                        col2.innerHTML = String(feature.properties[k]).trim().length == 0 ? "&nbsp;" : feature.properties[k];
                    }

                    // -- select layers data

                    divTxtLayers.textContent = 'layer:'
                    msg.innerHTML='Selezionare gli attributi dal layer desiderato. L\'oggetto sar&agrave salvato in quel layer. E\' sempre \
                    possibile modificare layer ma si perderanno i dati inseriti.\n'

                    // -- select tag options

                    var aLayerNames = objLayers.getLayerNamesByType('short','asc',true),
                        editableLayers= {};

                    for (var ol=0; ol<aLayerNames.length;ol++){
                        editableLayers[aLayerNames[ol]['layerName']] = objLayers.aLayers[aLayerNames[ol]['level']][aLayerNames[ol]['wfst']]
                        console.log('\'' + aLayerNames[ol]['layerName'] + '\'=' + editableLayers[aLayerNames[ol]['layerName']]
                        )
                    }

                    for(var el in editableLayers)
                    {
                        var opt = document.createElement("option");
                        opt.value= el;
                        opt.text = el; 

                        selLayers.appendChild(opt);
                    }

                    selLayers.addEventListener('change', function () {
                        var r = editableLayers[this.value] == null ? null : editableLayers[this.value].readFormat.featureType.fieldTypes;
                        console.log(
                            'editableLayers[' + this.value + ']=',
                            r
                        )
                    });

                    
                    popup
                        .setLatLng(coords)
                        .setContent(div)
                        .openOn(map);
                    //makeDraggable(popup);
                }

                // -- test featurePropertyManager

                objTest.checkFeaturePropertyManager(featurePropertyManager, map);

                function confirmPopup(msg, aParms, coords, callBack) {
                /***
                * generic popup with yes and no button:
                * msg:        message to show 
                * aParms:     array of parameters to pass to callBack function
                * coords:     latlng coords where to show popup
                * callBack:   callBack function to call after buttons yes|no clicked
                * Note that the true|false parameter passed to the callback function
                * to instruct if yes (true) or no (false) button was pressed, is
                * added as the last element of aParms parameters array.
                ***/
                   
                    // -- popup interface 
                    
                    var div = L.DomUtil.create('div'),
                        txt = L.DomUtil.create('div','',div),
                        btDiv = L.DomUtil.create('div','',div),
                        btYes =L.DomUtil.create('button','',btDiv),
                        btNo =L.DomUtil.create('button','',btDiv);

                    // -- styles

                    div.style.cssText ='width:150px;height:100px';
                    btYes.style.cssText=' display:inline-block; width: 30px; /*float:left;*/ margin:3px;margin-right:' +
                        String(150 - 72) + 'px';
                    btNo.style.cssText='display:inline-block; width: 30px; /*float:right;*/ margin:3px';
                    btDiv.style.cssText='margin-top:20px; background-color:#e0e0d1';
                    
                    // -- text contents
                    txt.textContent=msg;
                    btYes.textContent='si';
                    btNo.textContent='no';
                    
                    // buttons click event listeners

                    btYes.addEventListener('click',function(){
                        aParms.push(true);
                        callBack.apply(this,aParms);
                        popup._close();
                    });

                    btNo.addEventListener('click',function(){
                        aParms.push(false);
                        callBack.apply(this,aParms);
                    });
 
                    // -- popup activation and enable dragging

                    popup.setLatLng(coords)
                        .setContent(div)
                        .openOn(map);
                    makeDraggable(popup);
                }
                
                // -- test confirmPopup

                // checkConfirmPopup();

                function showAttributes(feature, coords) {
                    /***
                    * shows feature attributes popup:
                    * feature: feature object (example e.layer.feature)
                    * coords:  where to show popup on map (example e.latlng)
                    ***/

                    var div = L.DomUtil.create('div');
                    div.className = 'AttribInfoDiv';
                    var d1 = L.DomUtil.create("div", "AttribInfoLabel", div),
                        d2 = L.DomUtil.create("div", "AttribInfoValue", div),
                        r1, r2;
                    //r1 = L.DomUtil.create("div", "rowAttribInfoLabel", d1);
                    //r2 = L.DomUtil.create("div", "rowAttribInfoValue", d2);
                    //r1.textContent = "sigla prov";
                    //r2.textContent = currentAdminLimits.siglaProv;
                    //r1 = L.DomUtil.create("div", "rowAttribInfoLabel", d1);
                    //r2 = L.DomUtil.create("div", "rowAttribInfoValue", d2);
                    //r1.textContent = "foglio corrente";
                    //r2.textContent = currentLayer.foglio;

                    for (var k in feature.properties) {
                        r1 = L.DomUtil.create("div", "rowAttribInfoLabel", d1);
                        r2 = L.DomUtil.create("div", "rowAttribInfoValue", d2);
                        r1.textContent = k;
                        r2.innerHTML = String(feature.properties[k]).trim().length == 0 ? "&nbsp;" : feature.properties[k];
                    }
                    popup
                        .setLatLng(coords)
                        .setContent(div)
                        .openOn(map);
                    makeDraggable(popup);
                }

                function updateCurrentStatus(feature, options) {
                    /*-----------------------------------------------------
                    update currentLayer and CurrentAdminLimits data:
                    feature: feature object (example e.layer.feature)
                    options:  layer options (example e.layer.options)
                    -----------------------------------------------------*/

                    currentLayer.feature = feature;
                    currentLayer.nameSpace = options.typeNS;
                    currentLayer.name = options.typeName;
                    currentLayer.layerName = currentLayer.nameSpace + ':' + currentLayer.name;
                    currentLayer.level = objLayers.getLevelByLayerName(currentLayer.name);
                    if (currentLayer.name == objLayers.aLayers[0]["tiled_Comuni"].options.layers[0].split(":")[1]) {
                        currentAdminLimits.siglaProv = feature.properties["DescProvincia"].split('/')[1];
                        currentAdminLimits.descProv = feature.properties["DescProvincia"].split('/')[0];
                        currentAdminLimits.comune= feature.properties["IDComune"].substr(0, 4); 
                        currentAdminLimits.descComune = feature.properties["DescComune"];
                        // -- added Comune
                    }
                    if (currentLayer.name == objLayers.aLayers[1]["tiled_Fogli"].options.layers[0].split(":")[1]) {
                        currentAdminLimits.siglaProv = feature.properties["provincia"];
                        currentAdminLimits.stringaFoglio = feature.properties["FOGLIO"];
                        currentAdminLimits.foglio = parseInt(currentAdminLimits.stringaFoglio.substr(4, 3)); 
                        // -- corrected!!
                    }
                    if (
                          currentLayer.name == objLayers.aLayers[2]["tiled_Particelle"].options.layers[0].split(":")[1]
                       || currentLayer.name == objLayers.aLayers[3]["tiled_PoligoniSigaf"].options.layers[0].split(":")[1]
                       )  currentAdminLimits.part = parseInt(feature.properties["PART"]);
                    //-- added particella
                }

                function buildWfstFilters(feature) {
                    var aFiltComuni = [],
                        fc = null;
                    if (currentLayer.feature != null) {
                        switch (currentLayer.name) {
                            case "SIGAF_Vista_Poligoni_Attuali":
                                break;
                            case "TOSC_BordiFoglio":
                                filterFoglio = new L.Filter.EQ('FOGLIO', currentAdminLimits.stringaFoglio);
                                break;
                            case "TOSC_Comuni":
                                /***
                                * Or filter like this sql clause (example from click on Arezzo):
                                * foglio like 'N001%' or foglio like 'N002%' or foglio like 'N003%'
                                * 
                                * Generate or filter for first two Comune|Sezione codes;
                                * to add other codes (3,4,...n) to or filter
                                * simply add code to array filterComune.filters property 
                                * of filterComune.
                                ***/
                                filterComune = JSON.parse(feature.properties["jsonCodSezioni"])
                                for (fc in filterComune) {
                                    aFiltComuni.push(new L.Filter.Like('FOGLIO', filterComune[fc] + "*"));
                                };
                                if (aFiltComuni.length == 1)
                                    filterComune = aFiltComuni[0];
                                else {
                                    filterComune = new L.Filter.Or(aFiltComuni[0], aFiltComuni[1]);
                                    if (aFiltComuni.length > 2) {
                                        for (fc = 2; fc < aFiltComuni.length; fc++) {
                                            filterComune.filters[filterComune.filters.length] = aFiltComuni[fc];
                                        }
                                    }
                                }
                        }
                    }

                }

                /* ---------------------------------- 
                wfst layer click event handler.
                ---------------------------------- */

                function wfstClick(e) {

                    var showAttr=true,
                        thisLayer= e.layer||e.target,
                        // -- e.layer is undefined for new drawn features (no .feature property). In this case use e.target
                        idLayer = thisLayer._leaflet_id;


                    // -- disable handler in drawing mode of leaflet.pm

                    console.log(
                        'wfstClick: pmStatus.isactive=',
                        pmStatus.isActive
                    );

                    if (pmStatus.isActive && !pmStatus.isDelete) {console.log('...exiting immediately from wfst vector layer click event'); return}

                    // -- remove not modified previous selected layer if edited features to save exists

                    if (numProperties(editedFeatures)>1 && 
                            exists(editedFeatures[idLayer])) { 
                        if(editedFeatures[idLayer].modified==true) {
                            showAttr = false;
                            confirmPopup(
                                'questo oggetto è stato modificato o creato ex novo. Confermi la cancellazione ?', 
                                [thisLayer], 
                                e.latlng, 
                                function (layer, deleteIt) {
                                    if (deleteIt) {
                                        map.removeLayer(layer);
                                        delete editedFeatures[layer._leaflet_id];
                                        editedFeatures.modified -= 1;
                                    } else {
                                        if(exists(thisLayer.feature)) 
                                            showAttributes(thisLayer.feature, e.latlng)
                                        else
                                            popup._close()
                                    }
                                }
                            );
                        } else {
                            console.log(
                                'wfstClick on layer: removing wfst feature reserved for editing mode as not modified'
                            );
                            map.removeLayer(thisLayer);
                            delete editedFeatures[thisLayer._leaflet_id];
                        }
                    } 


                    if(exists(thisLayer.feature)) {

                        // -- update array of identified features id

                        aEventPath.push(thisLayer.feature.id);

                        // -- update currentLayer and CurrentAdminLimits data

                        updateCurrentStatus(thisLayer.feature, e.target.options);

                        // -- builds wfst requests filters based on currentLayer, CurrentAdminLimits and current feature data

                        buildWfstFilters(thisLayer.feature);

                        // -- shows identified feature properties popup

                        if (showAttr) showAttributes(thisLayer.feature, e.latlng);
                    }
                }

                /* ---------------------------------- 
                map click event handler.
                -------------------------------------

                1)
                manages click on map (bubbling after click on wfst layer) based on 
                aEventPath array of identified features id created by wfst layers click event handler.
                If aEventPath array is not empty then this handler empties the array and returns
                without creating other wfst layers. 
                So doing this handler builds wfst layers when directly started
                by a map click event and not when started by bubbling of wfst layer event.

                By now the layerCreated flag is managed to allow only the top level wfst layer creation.
                It is also possible to create all wfst layers allowed at current zoom.

                2)
                Calculates bounding box at current latlong with 1 m. x 1 m. size. (not well coded -- modify)
                
                3)
                Builds wfst layers if allowed at current zoom level by minZoom and mapZoom options
                properties pre configured for each wfst layer
                with filter based on current mouse coordinates
                ---------------------------------- */

                function onMapClick(e) {

                    // -- disable handler in drawing mode of leaflet.pm

                    console.log(
                        'onMapclick: pmStatus.isactive=',
                        pmStatus.isActive
                    );

                    if (pmStatus.isActive) { console.log('...exiting immediately from event'); return}
                    var currentZoom = map.getZoom();

                    if (aEventPath.length > 0 ) { // && numProperties(editedFeatures)<=1
                        console.log(
                            'Event bubbled from layer click. Exiting without attempting to get any wfst feature from server.'
                        )
                        aEventPath = [];
                        return
                    }
                    var firstLayer=true,
                        clickLatLngMin3003 = L.CRS.EPSG3003.project  (e.latlng),
                        clickLatLngMax = L.CRS.EPSG3003.unproject({
                            x: clickLatLngMin3003.x + 0.1,
                            y: clickLatLngMin3003.y + 0.1
                        }),
                        bBox = new L.Filter.BBox('geom',
                        L.latLngBounds(e.latlng,
                        clickLatLngMax),
                        L.CRS.EPSG3003),
                        selectedLevel = null,
                        selectedName=null,
                        selectedTiledName = null,
                        selectedMinZoom = null,
                        selectedMaxZoom = null,
                        filter = null,
                        //-- status flag for forcing one only layer creation
                        layerCreated = false,      
                        options = wfstUtil.getTemplateWfst().options,
                        aTiledLayers = objLayers.getLayerNamesByType("tiled","desc",false),
                        aWfstLayers = objLayers.getLayerNamesByType("wfst","desc");

                    // -- scan all wfst map layers ---------------------------------
                    for (var k = 0; k < aWfstLayers.length; k++) {
                        selectedLevel = aWfstLayers[k]["level"];
                        selectedName = aWfstLayers[k]["layerName"];
                        selectedTiledName = aTiledLayers[k]["layerName"];
                        selectedMinZoom = objLayers.aLayers[selectedLevel].minZoom;
                        selectedMaxZoom = objLayers.aLayers[selectedLevel].maxZoom;

                        // -- remove previous identified features but only if not modified by editor.

                        if (objLayers.aLayers[selectedLevel][selectedName] != null) {

                            console.log(
                                {
                                    layer_Level: selectedLevel,
                                    layeType_And_Name: selectedName,
                                    fatures_number: (objLayers.aLayers[selectedLevel][selectedName]._map != null
                                        && exists(objLayers.aLayers[selectedLevel][selectedName]._map._renderer) ? numProperties(objLayers.aLayers[selectedLevel][selectedName]._map._renderer._layers) : 0),
                                    srsName: objLayers.aLayers[selectedLevel][selectedName].options.srsName,
                                    minZoom: selectedMinZoom,
                                    maxZoom: selectedMaxZoom,
                                    style: objLayers.aLayers[selectedLevel][selectedName].options.style
                                }
                            );

                            if (exists(map._layers[objLayers.aLayers[selectedLevel][selectedName]._leaflet_id])
                                && numProperties(editedFeatures) <= 1) {
                                console.log(
                                    'removing from map previous identified ' + selectedName + ' feature at level ' + String(selectedLevel)
                                );
                                map.removeLayer(objLayers.aLayers[selectedLevel][selectedName]);
                            } else
                                if (numProperties(editedFeatures) > 1)
                                    console.log(
                                        '... not removing previously identified ' + selectedName + ' features at level ' + String(selectedLevel) + ' as they are reserved for  editing'
                                    );
                                else
                                    console.log('not previously identified ' + selectedName + ' features at level ' + String(selectedLevel)
                                    );
                        }

                        // -- skip deselected tiled layers (not connected to map)

                        if (!exists(objLayers.aLayers[selectedLevel][selectedTiledName]._map)
                            || objLayers.aLayers[selectedLevel][selectedTiledName]._map==null
                            ) continue; 

                        if (currentZoom <= selectedMaxZoom && currentZoom >= selectedMinZoom) {

                                //-- builds current filter before WFS query

                                switch (selectedName){
                                    case "wfst_SIGAF_Vista_Poligoni_Attuali":
                                    case "wfst_TOSC_Particelle":
                                        if (filterFoglio != null)
                                            filter = new L.Filter.And(filterFoglio, bBox);
                                        else
                                            filter = bBox;
                                        break;
                                    case "wfst_TOSC_BordiFoglio":
                                        if (filterComune != null) {
                                            filter = new L.Filter.And(filterComune, bBox);
                                            //filter=filterComune;
                                            //filter.filters[filter.filters.length]=bBox;
                                        }
                                        else
                                            filter = bBox;
                                        break;
                                    case "wfst_TOSC_Comuni":
                                        filter = bBox;
                                }

                                // - create wfst layers: by now only one 

                                //currentLayer.level=selectedLevel;
                                //currentLayer.layerName=selectedName;

                                objLayers.aLayers[selectedLevel][selectedName] = wfstUtil.wfstLayerCreate(
                                    firstLayer,
                                    options, 
                                    filter, 
                                    currentZoom, 
                                    selectedMinZoom, 
                                    selectedMaxZoom, 
                                    "ARTEA", 
                                    selectedName.substr(selectedName.indexOf('_') + 1),
                                    objLayers,
                                    e.latlng
                                );
                                firstLayer=false;
                        }
                    }
                    // -- end scan all wfst map layers -----------------------------

                }

                // -- connect map click event to handler

                map.on('click', onMapClick);

                //function onMapClickTest(e) {
                //    var dotPitch = 1 / meterWidthInPixels() * 1000;
                //    popup
                //        .setLatLng(e.latlng)
                //        .setContent(
                //            "You clicked the map at " + e.latlng.toString() + "<br/>Current zoom is " + String(map.getZoom()) +
                //            "<br/>Current calculated scale is " + String(getScaleFromScaleControl(scaleControl)) + 
                //            "<br/>on this computer dot pitch is  " + String(dotPitch) + " mm."
                //        )
                //        .openOn(map);
                //}


                /***
                * manages Editing functions using Leaflet.Pm plugin
                * ------------------------------------------------
                ***/

                // add leaflet.pm editor controls with all options to the map

                map.pm.addControls({
                });

                /*
                const customTranslation = {
                    "tooltips": {
                        "placeMarker": "Clicca per posizionare un Marker",
                        "firstVertex": "Clicca per posizionare il primo vertice",
                        "continueLine": "Clicca per continuare a disegnare",
                        "finishLine": "Clicca qualsiasi marker esistente per terminare",
                        "finishPoly": "Clicca il primo marker per terminare",
                        "finishRect": "Clicca per terminare",
                        "startCircle": "Clicca per posizionare il punto centrale del cerchio",
                        "finishCircle": "Clicca per terminare il cerchio"
                    },
                    "actions": {
                        "finish": "Termina",
                        "cancel": "Annulla",
                        "removeLastVertex": "Rimuovi l'ultimo vertice"
                    },
                    "buttonTitles": {
                        "drawMarkerButton": "Disegna Marker",
                        "drawPolyButton": "Disegna Poligoni",
                        "drawLineButton": "Disegna Polilinea",
                        "drawCircleButton": "Disegna Cerchio",
                        "drawRectButton": "Disegna Rettangolo",
                        "editButton": "Modifica Livelli",
                        "dragButton": "Sposta Livelli",
                        "cutButton": "Ritaglia Livelli",
                        "deleteButton": "Elimina Livelli"
                    }
                };
                */

                /*-- file it.json:
                {
                  "tooltips": {
                    "placeMarker": "Clicca per posizionare un Marker",
                    "firstVertex": "Clicca per posizionare il primo vertice",
                    "continueLine": "Clicca per continuare a disegnare",
                    "finishLine": "Clicca qualsiasi marker esistente per terminare",
                    "finishPoly": "Clicca il primo marker per terminare",
                    "finishRect": "Clicca per terminare",
                    "startCircle": "Clicca per posizionare il punto centrale del cerchio",
                    "finishCircle": "Clicca per terminare il cerchio"
                  },
                  "actions": {
                    "finish": "Termina",
                    "cancel": "Annulla",
                    "removeLastVertex": "Rimuovi l'ultimo vertice"
                  },
                  "buttonTitles": {
                    "drawMarkerButton": "Disegna Marker",
                    "drawPolyButton": "Disegna Poligoni",
                    "drawLineButton": "Disegna Polilinea",
                    "drawCircleButton": "Disegna Cerchio",
                    "drawRectButton": "Disegna Rettangolo",
                    "editButton": "Modifica Livelli",
                    "dragButton": "Sposta Livelli",
                    "cutButton": "Ritaglia Livelli",
                    "deleteButton": "Elimina Livelli"
                  }
                }
                */

                // -- map.pm.setLang not jet released

                //map.pm.setLang('it');
                //map.pm.setLang('customTranslation', customTranslation, 'en');

                /*------------- ----------- ---------------------------------
                |Option         Default	    Description
                 -------------- ----------- ---------------------------------
                |position	    topleft'    toolbar position, 
                |                           possible values are: 
                |                           'topleft', 
                |                           'topright', 
                |                           'bottomleft', 
                |                           'bottomright'
                |drawMarker	    true	    adds button to draw markers
                |drawPolyline	true	    adds button to draw rectangle
                |drawRectangle	true	    adds button to draw rectangle
                |drawPolygon	true	    adds button to draw polygon
                |drawCircle	    true	    adds button to draw cricle
                |editMode	    true	    adds button to toggle edit mode for all layers
                |dragMode	    true	    adds button to toggle drag mode for all layers
                |cutPolygon	    true	    adds button to cut a hole in a polygon
                |removalMode	true	    adds a button to remove layers
                *-------------- ----------- ---------------------------------*/

                /***
                * manages  pmStatus{} (Leaflet.pm  editor toolbar status object)
                * ------------------- ------------------------------------------ 
                * The isActive property, if true, blocks all the wfst identify fuctions
                * so editing activity takes place in an isolated environment
                * without interfere with identify activity.
                ***/

                var counterDraw=0,       // draw operation id# number
                    workingLayer=null,   // Leaflet.Pm currently drawn layer
                    editedFeatures={},   // object with edited feature to save.
                    aAttributes=[];      // alfanumerical attributes objects array saved from edited wfst features 
                // [{layerName_1:{properties_1}, layerName_2:{properties_2,...,layerName_n:{properties_n}]
 
                // -- assign to  workingLayer var. Leaflet.PM workingLayer passed as w
                function createWorkingLayer(w) {
                    workingLayer=w;
                    console.log(
                        'workingLayer',
                        workingLayer
                    );
                    addWorkingLayerEvents(w);
                }

                /***
                * fills transparent workingLayer features
                * w   -> workingLayer._renderer
                * rgb -> rgb string for fill color and transparency
                ***/

                function editingFeaturesFill(w, rgb) {
                    var attr;
                    if (exists(w._layers)) {
                        for (var k in w._layers) {
                            attr= w._layers[k]._path.attributes;
                            for (var kk in attr) {
                                if (attr[kk].nodeName=='fill' && attr[kk].nodeValue=='none') {
                                    attr[kk].nodeValue=rgb;
                                    console.log('layer:',w._leaflet_id,'attributes index:',kk, attr[kk].nodeName + ':', rgb);
                                };
                            }
                        }
                    }
                }

                map.on('pm:create', e => {
                    console.log(
                        'pm:create',
                        'e=',
                        e
                    );
                });

                map.on('pm:edit', e => {
                    console.log(
                        'pm:edit',
                        'e=',
                        e
                    );
                });

                map.on('pm:remove', e => {
                    console.log(
                        'pm:remove',
                        'e=',
                        e
                    );
                    editedFeatures = getEditedFeatures(workingLayer, editedFeatures, null);
                    // -- temporarily reinsert deleted layer !!
                    e.layer.addTo(map);
                });

                map.on('pm:modified', e => {
                    console.log(
                        'pm:modified',
                        'e=',
                        e
                    );
                });

                /***
                * pm:drawstart - fired from click on drawing 
                *                (marker, polyline, rectangle, polygon, circle) 
                ***/
                map.on('pm:drawstart', function(e){
                    if(allLayers==null) allLayers=e.target._layers;
                    counterDraw++;
                    pmStatus.set('isDraw',true);
                    console.log(
                        String(counterDraw) + '|pm:drawstart ',
                        'pmStatus=',
                        pmStatus.show(),
                        'allLayers=',
                        allLayers
                    );
                    /***
                    * gets current working layer: workingLayer._renderer._layers 
                    * contains layer list having features _latlngs;
                    * Only the wfst layer contains layer.feature.coordinates (projectedt coords.).
                    ***/
                    if(workingLayer==null) createWorkingLayer(e.target);
                });


                // -- manages currently drawn layer events
                function addWorkingLayerEvents(workingLayer)
                {
                    // -- vertex added pm:vertexadded
                    workingLayer.on('pm:vertexadded',function(e) {
                        if(allLayers==null) allLayers=e.sourceTarget._map._layers;
                        console.log(
                            String(counterDraw) + '|pm:vertexadded',
                            'allLayers=',
                            allLayers,
                            'e=',
                            e
                        );
                    });
                    // -- vertex removed
                    workingLayer.on('pm:vertexremoved',function(e) {
                        console.log(
                            String(counterDraw) + '|pm:vertexremoved',
                            'e=',
                            e
                        );
                    });
                    // -- edit
                    workingLayer.on('pm:edit',function(e) {
                        console.log(
                            String(counterDraw) + '|pm:edit',
                            'e=',
                            e
                        );
                    });
                    // -- click
                    //workingLayer.on('click',function(e) {
                    //    print( ' ' + String(counterDraw) +'|pm:click\n');
                    //    console.log(e);
                    //})
                    // -- drag
                    //workingLayer.on('drag',function(e) {
                    //    print( ' ' + String(counterDraw) +'|pm:drag\n');
                    //    console.log(e);
                    //})
                    // -- snap
                    workingLayer.on('pm:snap',function(e) {
                        console.log(
                            String(counterDraw) + '|pm:snap',
                            'e=',
                            e
                        );
                    })
                    // -- unsnap
                    workingLayer.on('pm:unsnap',function(e) {
                        console.log(
                            String(counterDraw) + '|pm:unsnap',
                            'e=',
                            e
                        );
                    })
                    // -- snapdrag
                    //workingLayer.on('pm:snapdrag',function(e) {
                    //    print( ' ' + String(counterDraw) +'|pm:snapdrag\n');
                    //    console.log(e);
                    //})
                    // -- markerdragstart
                    //workingLayer.on('pm:markerdragstart',function(e) {
                    //    print( ' ' + String(counterDraw) +'|pm:markerdragstart\n');
                    //    console.log(e);
                    //})
                    // -- markerdragend
                    //workingLayer.on('pm:markerdragend',function(e) {
                    //    print( ' ' + String(counterDraw) +'|pm:markerdragend\n');
                    //    console.log(e);
                    //})
                    // -- cut
                    workingLayer.on('pm:cut',function(e) {
                        console.log(
                            String(counterDraw) + '|pm:cut',
                            'e=',
                            e
                        );
                    })
                    // -- modified
                    workingLayer.on('pm:modified',function(e) {
                        console.log(
                            String(counterDraw) + '|pm:modified',
                            'e=',
                            e
                        );
                    })
                };

                // -- pm:drawend

                map.on('pm:drawend', function(e){
                    var drawType =pmStatus.drawType,
                        lid='';
                    if(allLayers==null) allLayers=e.target._layers;
                    pmStatus.set('isDraw',false);
                    pmStatus.set('drawType',null);
                    console.log(
                        String(counterDraw) + '|pm:drawend',
                        'pmStatus=',
                        pmStatus.show(),
                        "workingLayer=",
                        workingLayer,
                        "e.target=",
                        e.target,
                        "editedFeatures=",
                        editedFeatures
                    );
                    editedFeatures=getEditedFeatures(workingLayer,editedFeatures,drawType);
                    // -- adds wfstClick event handler to click event of layer just now created 
                    for (var k in e.target._renderer._layers) {
                        if (!e.target._renderer._layers[k].hasEventListeners('click'))
                            e.target._renderer._layers[k].on('click', wfstClick);
                    }
                });

                /***
                * pm:globaleditmodetoggled - fired from click on Edit Layers btn. 
                *                            and from click on Cancel near same btn.
                ***/

                map.on('pm:globaleditmodetoggled', e => {
                    if(allLayers==null) allLayers = e.target._layers;
                    pmStatus.toggle('isGlobalEdit');
                    if(pmStatus.isGlobalEdit) {
                        counterDraw++;
                        if(workingLayer==null) createWorkingLayer(e.target);
                    }
                    console.log(
                        String(counterDraw) + '|globaleditmodetoggled',
                        'pmStatus=',
                        pmStatus.show(),
                        "workingLayer=",
                        workingLayer,
                        "e.target=",
                        e.target,
                        "editedFeatures=",
                        editedFeatures
                    );
                    // -- fills all in editing features with FillColor
                    if(exists(e.target._renderer)) {
                        editingFeaturesFill(e.target._renderer, editedFeaturesFillColor);
                        editedFeatures=getEditedFeatures(workingLayer,editedFeatures,null);
                    }
                    console.log('editedFeatures=',editedFeatures);
                });

                function getEditedFeatures(workingLayer,editedFeatures,drawType) {
                    /***
                    *  compose an edited features object from a Leaflet.Pm plugin working layer.
                    *  object structure:
                    *  {
                    *  [feature:{...},]  feature property exists only in wfst features selected before editing. 
                    *                    It's not possible to insert feature property and data in Leaflet.Pm 
                    *                    edited feature group layers because so doing this features 
                    *                    are probably treated as just saved from Leaflet.Pm/Leaflet.wfst 
                    *                    and no more visualized during editing.
                    *                    feature.geometry.coordinates, feature.geometry.type, feature.properties,
                    *                    feature.id
                    *
                    *  modified          integer: number of modified features in the group 
                    *                    with editor so needs to be saved.
                    *  drawType          (circle|rectangle|polygon|polyline) name of button used when drawing 
                    *  _latlngs: {...}   (internal Leaflet coords in lat. lng.)
                    *  }
                    * Parameters:
                    * workingLayer:      Leaflet.Pm working layer from pm:globaleditmodetoggled -> e.target or pm:drawStart -> e.workingLayer.
                    *                    workingLayer._renderer._layers contains all edited layers (for each layer only one feature were observed).
                    * editedFeatures:    (May be ={} at the first call of this function) Global object builded from workingLayer
                    *                    edited feature grop layers during the previous call of this function.
                    *                    This function builds actual editedFeatures object in objFeature object and 
                    *                    returns objFeature object.
                    * drawType:       1) Current drawtype passed from pm:drawend event handler and containing (always lowercase) 'polygon' or 'polyline'
                    *                    ('circle' and 'rectangle' are not of interest for gis operations).
                    *                    It is used for detecting correct feature type  when building projected coordinates 
                    *                    with featureUtils.projectNestedLatLng() method. After this method call
                    *                    correct feature.geometry.type is available from featureUtils.featureType property.
                    *                 2) null passed from globaleditmodetoggled event handler. In this case the correct feature.geometry.type
                    *                    already exists in previous editedFeatures object if the object were created  and passed from 
                    *                    pm:drawend event handler. If the object is a wfst feature selected by click before editing then
                    *                    must be inserted into editedFeatures object. Note that this feature already contains the 'feature'
                    *                    property.
                    ***/
                    var objFeatures ={},     // 
                        oldCoordsArray='',   // current feature previous coords array
                        newCoordsArray='',   // current feature new coords. array from workingLayer._renderer._layers[lid]._latlngs
                        crs=L.CRS.EPSG3003,  // default crs for Italian coordinates of Tuscany region
                        featureType=null;    // detected feature.type of current feature

                    console.log(
                        "editedFeatures=",
                        editedFeatures,
                        "objLayers=",
                        objLayers
                    );

                    objFeatures.modified= exists(editedFeatures) && exists(editedFeatures.modified) ? editedFeatures.modified:0;

                    if(workingLayer==null) {
                        console.log(
                            'getEditedFeatures: workingLayer Object is NULL - this must never happens for a correct function call!')
                        return ; // this must never happens for a correct function call!
                    }

                    // -- scan Leaflet.Pm edited features group
                    
                    for (var lid in workingLayer._renderer._layers) {

                        objFeatures[lid]={};
                        newCoordsArray = workingLayer._renderer._layers[lid]._latlngs;

                        // -- (0) - ok - building of objFeatures properties common to all cases
                        
                        objFeatures[lid].feature    = {'geometry':{'coordinates':null,'type':null},'type':null};
                        objFeatures[lid]._latlngs    = workingLayer._renderer._layers[lid]._latlngs;

                        if(exists(editedFeatures[lid])) {
                            // -- (1) - ok  - pre existing features already contained in editedFeatures:
                            //    get oldCoordsArray from editedFeatures
                            //    
                            oldCoordsArray                       = editedFeatures[lid]._latlngs;
                            drawType                             = editedFeatures[lid].drawType;

                            objFeatures[lid].feature.properties  = JSON.parse(JSON.stringify(editedFeatures[lid].feature.properties));
                            objFeatures[lid].feature.id          = editedFeatures[lid].feature.id;
                            
                            if (featureUtils.compareNestedCoordsArray(newCoordsArray,oldCoordsArray)== false) {

                                // -- set feature modified as geometry is modified
                                
                                workingLayer._renderer._layers[lid].modified=true;
                                objFeatures[lid].modified=true;
                                objFeatures.modified+=1;

                                // -- create new or modified feature.geometry.coordinates (projected coords.) from _latlngs and feature.geometry.type
                                
                                objFeatures[lid].feature.geometry.coordinates = featureUtils.projectNestedLatLng(workingLayer._renderer._layers[lid]._latlngs, drawType,crs);
                                objFeatures[lid].feature.geometry.type        = featureUtils.featureType;
                                objFeatures[lid].feature.type                 = featureUtils.featureType;
                            } else {
                                // -- feature geometry not modified:
                                //    copy from editedFeature object old properties feature.geometry.coordinates and type, feature.type, modified 
                                objFeatures[lid].feature.geometry.coordinates = JSON.parse(JSON.stringify(editedFeatures[lid].feature.geometry.coordinates));
                                objFeatures[lid].feature.geometry.type        = editedFeatures[lid].feature.geometry.type;
                                objFeatures[lid].feature.type                 = editedFeatures[lid].feature.type;
                                objFeatures[lid].modified                     = editedFeatures[lid].modified;
                            }
                        }
                        else if(exists(workingLayer._renderer._layers[lid].feature) && exists(workingLayer._renderer._layers[lid].feature.id)) {
                            // -- (2) - ok - first time treated wfst feature: 
                            //    set objFeatures[lid].modifyed to false
                            //    builds featureType, crs, objFeatures[lid].feature, drawType

                            // -- with this it's not necessary to set modified property into wfst features!!

                            objFeatures[lid].modified                    = false;   
                            workingLayer._renderer._layers[lid].modified = false;
                           
                            featureType = workingLayer._renderer._layers[lid].feature.geometry.type;
                            drawType    = workingLayer._renderer._layers[lid].feature.geometry.type.toLowerCase().replace(/multi/g, '');
                            crs         = workingLayer._renderer._layers[lid].options.crs;

                            objFeatures[lid].feature.geometry.coordinates = JSON.parse(JSON.stringify(workingLayer._renderer._layers[lid].feature.geometry.coordinates));
                            objFeatures[lid].feature.geometry.type        = workingLayer._renderer._layers[lid].feature.geometry.type;
                            objFeatures[lid].feature.type                 = workingLayer._renderer._layers[lid].feature.geometry.type;
                            objFeatures[lid].feature.properties           = JSON.parse(JSON.stringify(workingLayer._renderer._layers[lid].feature.properties));
                            objFeatures[lid].feature.id                   = workingLayer._renderer._layers[lid].feature.id;

                            // -- add new  property object to tmpLayerName property of aAttributes object;

                            var tmpLayerName= workingLayer._renderer._layers[lid].feature.id.split('.')[0],
                                pind=null;
                            if (!exists(aAttributes[tmpLayerName])) {
                                pind=aAttributes.push({});
                                aAttributes[pind-1]= {layerName: tmpLayerName,properties: {}};
                                for (var key in workingLayer._renderer._layers[lid].feature.properties)
                                    aAttributes[pind-1]['properties'][key] = workingLayer._renderer._layers[lid].feature.properties[key];
                                
                                var thisInstant = new Date().toISOLocalDateTime();
                                for (var pn in aAttributes[pind-1]['properties'])
                                    if (['provincia','foglio','part','sub'].indexOf(pn.toLowerCase())<0)
                                        switch (pn.toLowerCase()){
                                            case 'm_dfv': aAttributes[pind-1]['properties'][pn]='9999-12-31T00:00:00';
                                                break;
                                            case 'm_div': 
                                            case 'm_dm':
                                                aAttributes[pind-1]['properties'][pn]=thisInstant;
                                                break;
                                            default: aAttributes[pind-1]['properties'][pn]=''
                                        }
                            }
                        }
                        else {
                            // -- (3) - ok  new just drawed features (from draw end):  
                            //              oldCoordsArray does not exists so set oldCoordsArray to ''
                            //              set modified true for feature and global flag 
                            //              (at least one feature modified);
                            //              build feature.geometry.coordinates, feature.geometry.type and feature.type.
                            //oldCoordsArray = '';
                            
                            workingLayer._renderer._layers[lid].modified = true;          
                            objFeatures[lid].modified                    = true;   // single feature modified flag
                            objFeatures.modified                         += 1;     // global fature group modified flag (at least one featuree modified)

                            objFeatures[lid].feature.geometry.coordinates = featureUtils.projectNestedLatLng(workingLayer._renderer._layers[lid]._latlngs, drawType,crs);
                            objFeatures[lid].feature.geometry.type        = featureUtils.featureType;
                            objFeatures[lid].feature.type                 = featureUtils.featureType;
                            objFeatures[lid].feature.properties           = aAttributes.length>0 ?  JSON.parse(JSON.stringify(aAttributes[aAttributes.length -1]['properties'])):{};
                            objFeatures[lid].feature.id                   = null;
                        }

                        // -- set objFeatures[lid].drawType and options
                        
                        objFeatures[lid].drawType = drawType;  
                        objFeatures[lid].options  = {'crs': crs};
                      

                    };
                    // print current feature property of interest for debugging and return object

                    console.log('objFeatures=',objFeatures);
                    return objFeatures;
                }

                function updateEditedFeatures(){
                    // -- for degug 'update editedFeature button'
                    if(workingLayer!=null) 
                        editedFeatures = getEditedFeatures(workingLayer,editedFeatures,null);
                    else 
                        console.log ('workingLayer Object is NULL')
                };

                function printReportFeature(feature, name) {  // -- not used !!
                    /***
                    *  produce a debug report of feature parts and part points from:
                    *  feature: one of
                    *  - layer.feature.geom.coordinates (projected coords in wfst layer)
                    *  - layer._latlngs                 (internal Leaflet coords in lat. lng.)
                    *  - layer._rings                   (internal Leaflet coords in px.)
                    *    layer._parts                   (internal Leaflet coords in px (?))
                    *  name: name to display for feature
                    ***/
                    
                    console.log(
                        'name=',
                        name,
                        'level 1 objs=',
                        String(feature.length)
                    );
                    for (var k=0;k<feature.length;k++) {
                        console.log(
                            'level 2 obj[' + String(k) + ']=',
                            String(feature[k].length)
                        );
                    }
                }

                /***
                * Connect events to ToolBar icon-Buttons click and cancelButtons click
                * --------------------------------------------------------------------
                *
                * pm:(circle|rectangle|polygon|polyline|drag|cut|delete) mode toggled: simulated with click event listener on html tag:
                * <div class="button-container">
                *     <a class="leaflet-buttons-control-button">
                *         <div class="control-icon leaflet-pm-icon-polygon" title="Cut Layers"></div>
                *         (this is for Polygon mode btn.)
                *     </a>
                *     <div class="leaflet-pm-actions-container">
                *        [<a class="leaflet-pm-action action-finish">Finish</a>]
                *        [<a class="leaflet-pm-action action-removeLastVertex">Remove Last Vertex</a>]
                *        <a class="leaflet-pm-action action-cancel">Cancel</a>
                *        (this is for cancel btn.)
                *     </div>                
                * </div>
                * 
                * As pmStatus.isDraw, pmStatus.isGlobalEdit, pmStatus.isDrag, pmStatus.isDelete properties
                * alredy exists, we don't create events handlers for drag and delete buttons but only for 
                * circle,rectangle,polygon end polyline buttons. We are interested only to polygon and polyline
                * as circle  and rectangle are not gis related objects.
                ***/
                var aBtn= ['marker','polyline','rectangle','polygon','circle','drag','cut','delete'];
                for (var btnIndex=0 ;btnIndex<aBtn.length;btnIndex++ ) toolBarBtnAddEvents(aBtn[btnIndex]);
                
                // -- click on btn;
                function toolBarBtnAddEvents(name) {
                    var boolName='is'+ name.substr(0,1).toUpperCase() + name.substr(1);
                    document.getElementsByClassName('leaflet-pm-icon-' + name)[0].addEventListener('click', e => {
                        if(allLayers==null) allLayers = e.target._layers;
                        if(!exists(pmStatus[boolName])) 
                            pmStatus.set('drawType',name);
                        else {
                            pmStatus.set('drawType',null);
                            pmStatus.toggle(boolName);
                        }
                        console.log(
                            String(counterDraw),
                            '|pm:drawType=',
                            name,
                            'pmStatus=',
                            pmStatus.show()
                        );
                    });

                // -- click on cancel near btn;
                    document.getElementsByClassName('leaflet-pm-icon-' + name)[0].parentNode.nextSibling.lastChild.addEventListener('click', e => {
                        if(allLayers==null) allLayers = e.target._layers;
                        pmStatus.set('drawType', null);
                        if(exists(pmStatus[boolName])) {
                            pmStatus.set(boolName,false);
                            if (['isDelete','isDrag'].indexOf(boolName)>=0) { 
                                editedFeatures=getEditedFeatures(workingLayer,editedFeatures,null);
                                //pmStatus.set(boolName,false); -- da provare
                            }
                        }
                        console.log(
                            String(counterDraw),
                            '|pm:drawType=null ',
                            'pmStatus=',
                            pmStatus.show()
                        );
                    });
                }

                /***
                * end of manages  pmStatus{} (Leaflet.pm  editor toolbar status object)
                *        ------------------- ------------------------------------------ 
                ***/

                /***
                * end of manages Editing functions using Leaflet.Pm plugin
                *        -------------------------------------------------
                ***/

                /***
                * manages features saving activities
                * ----------------------------------
                ***/

                var featureUtils = {
                    projectBasicObjLatLng: function(BasicLatLngArray,objCrs) {
                    /***
                    * project a simple part array into the specified CRS
                    ***/
                            var coords=[],
                                p=null;
                        if (BasicLatLngArray.constructor.name=="Array") {
                            for (var k=0; k< BasicLatLngArray.length; k++) {
                                p=objCrs.project(BasicLatLngArray[k]);
                                coords.push([p.x,p.y]);
                            }
                        } else {
                            p=objCrs.project(BasicLatLngArray);
                            coords.push([p.x,p.y]);
                        }
                        return coords;
                    },
                    projectNestedLatLng: function(latLngArray,drawType,objCrs) {
                        this._featureType=null;
                        var coords=[];
                        // -- max nesting levels 4: [  [  [  [
                        //                          k1 k2 k3 
                        //                          ring|line string
                        //                             polygon|multilinestring
                        //                                multipolygon
                        //                                   geometry collection
                        if (latLngArray.constructor.name=="Array") {
                            for (var k1=0;k1<latLngArray.length;k1++)  {
                                if(latLngArray[k1].constructor.name=="Array") {
                                    coords.push([]);
                                    for (var k2=0;k2<latLngArray[k1].length;k2++) {
                                        if(latLngArray[k1][k2].constructor.name=="Array") {
                                            coords[k1].push();
                                            for (var k3=0;k3<latLngArray[k1][k2].length;k3++) 
                                                if(latLngArray[k1][k2][k3].constructor.name=="Array") {coords[k1][k2][k3].push(this.projectBasicObjLatLng(latLngArray[k1][k2][k3],objCrs));this._getFeatureType(4,drawType)}
                                                else if(k3==latLngArray[k1][k2].length-1) {coords[k1][k2]=this.projectBasicObjLatLng(latLngArray[k1][k2],objCrs);this._getFeatureType(3,drawType)}
                                        } else if(k2==latLngArray[k1].length-1) {coords[k1] = this.projectBasicObjLatLng(latLngArray[k1],objCrs);this._getFeatureType(2,drawType)}
                                    }
                                } else if(k1==latLngArray.length-1) {coords = this.projectBasicObjLatLng(latLngArray,objCrs);this._getFeatureType(1,drawType)}
                            }
                        } else
                        {coords = this.projectBasicObjLatLng(latLngArray,objCrs);this._getFeatureType(0,drawType)}
                        return coords
                    },
                    _featureType: null,
                    _getFeatureType: function (nestingLevel, drawType){
                        //drawType='marker'||'polyline'||'polygon'
                        if (drawType=='marker') this._featureType='Point';
                        else if (drawType=='polyline') {
                            if (nestingLevel==1) this._featureType='LineString';
                            else if (nestingLevel==2) this._featureType='MultiLineString';
                            else this._featureType=null;
                        }
                        else if (drawType=='polygon') {
                            if (nestingLevel==2) this._featureType='Polygon';
                            else if (nestingLevel==3) this._featureType='MultiPolygon';
                            else this._featureType=null;
                        }
                        else this._featureType=null;
                    },
                    compareNestedCoordsArray: function(nArr1,nArr2,drawType) {
                        this._featureType=null;
                        var coords=[];
                            // -- max nesting levels 4: [  [  [  [
                            //                          k1 k2 k3 
                            //                          ring|line string
                            //                             polygon|multilinestring
                            //                                multipolygon
                            //                                   geometry collection
                        if (nArr1.constructor.name=="Array") {
                            for (var k1=0;k1<nArr1.length;k1++)  {
                                if(nArr1[k1].constructor.name=="Array") {
                                    for (var k2=0;k2<nArr1[k1].length;k2++) {
                                        if(nArr1[k1][k2].constructor.name=="Array") {
                                            for (var k3=0;k3<nArr1[k1][k2].length;k3++) 
                                                if(nArr1[k1][k2][k3].constructor.name=="Array") {if(!this.compareCoordsArray([k1,k2,k3],nArr1[k1][k2][k3],nArr2[k1][k2][k3])) return false;}
                                                else if (k3 == nArr1[k1][k2].length - 1) { if (!this.compareCoordsArray([k1, k2],nArr1[k1][k2],nArr2[k1][k2])) return false;}
                                        } else if (k2 == nArr1[k1].length - 1) { if (!this.compareCoordsArray([k1],nArr1[k1],nArr2[k1])) return false;}
                                    }
                                } else if(k1==nArr1.length-1) {if(!this.compareCoordsArray([0],nArr1,nArr2)) return false;}
                            }
                        } else
                        {if(!this.compareCoordsArray([null],nArr1,nArr2)) return false;}
                        return true
                    },
                    compareCoordsArray: function (objNum,a1,a2) {
                        var prop1='lat',prop2='lng';
                        if (typeof(a1[0])=='object') {
                            if (exists(a1[0].x)) {
                                prop1='x';
                                prop2='y';
                            } 
                        }
                        else {
                            prop1=null;
                            prop2=null;
                        }

                        if (a1.length!=a2.length) return false;
                        if (prop1!=null) {
                            for (var k = 0; k < a1.length; k++)
                                if (a1[k][prop1] != a2[k][prop1] || a1[k][prop2] != a2[k][prop2]) {
                                    console.log(
                                        'indexes=',
                                        objNum,
                                        'last index=',
                                        k,
                                        prop1 + ': ',
                                        a1[k][prop1],
                                        a2[k][prop1],
                                        prop2 + ': ',
                                        a1[k][prop2],
                                        a2[k][prop2]
                                    );
                                    return false;
                                }
                        } else {
                            for (var k=0;k<a1.length;k++)
                                if (a1[k][0] != a2[k][0] || a1[k][1] != a2[k][1]) {
                                    console.log(
                                        'indexes=',
                                        objNum,
                                        'last index=',
                                        k,
                                        '0: ',
                                        a1[k][0],
                                        a2[k][0],
                                        '1: ',
                                        a1[k][1],
                                        a2[k][1]
                                    );
                                    return false;
                                }

                        }
                        return true;
                    }
                }
                Object.defineProperty(featureUtils, "featureType", {
                    get: function () { return this._featureType}
                });

                objTest.checkFeatureUtils(featureUtils,L.CRS.EPSG3003);

                /***
                * end of manages feature saving activities
                *        ---------------------------------
                ***/
            }   
            /***
            * End of initMap function: last level of closure:
            * ----------------------------------------------
            * Don't code after this bracket if you want tu use 
            * the closure environment !!!
            ***/
        })();

    </script>
    <style>
                html, body {height: 100%}
                html, body, select {font-family: Arial, Helvetica, sans-serif ;font-size: 11px}
                button {margin-top:8px;font:10px Verdana}

                #map {height: 768px; width: 1024px}

                @media (max-width: 600px) {
                    .foothead, #map {
                        width: 100%;
                    }

                }
                div.ScaleInfoLabel {display:inline-block;width:50px;text-align:right;margin-bottom:2px;color:blue;padding-right:3px;background-color:rgba(51, 159, 163, 0.52)}
                div.ScaleInfoValue {display:inline-block;width:50px; margin-bottom:2px; color:red;background-color:rgba(242, 232, 170, 0.50)}
                div.AttribInfoLabel{display:inline-block}
                div.AttribInfoValue {display:inline-block}
                .rowAttribInfoLabel {text-align:right;background-color:rgba(51, 159, 163, 0.52);color:blue;margin-bottom:2px;padding-right:3px}
                .rowAttribInfoValue {color:red;background-color:rgba(242, 232, 170, 0.50);margin-bottom:2px}
                .AttribInfoDiv {
                    border: 2px solid #777;
                    line-height: 1.1;
                    padding: 2px 5px 1px;
                    font-size: 11px;
                    white-space: nowrap;
                    overflow: hidden;
                    -moz-box-sizing: border-box;
                    box-sizing: border-box;
                    background: #fff;
                    background: rgba(255, 255, 255, 0.5);
                    color: #333;
                }

                /* -- featurePropertyManager popup -- */

                div.divLayers {border-radius:5px;margin-top:5px;margin-bottom:2px;padding-bottom:5px;width:300px; background-color:#e0e0d1}
                table.tAttrib{width:100%;border-collapse:collapse}
                tr.rowAttrib {border-collapse:collapse; border:2px solid white}
                td.colAttrib {border-collapse:collapse; border:2px solid white}
                select.selLayers {display:inline-block; margin:5px; margin-bottom:0px; width:220px}
                div.editAttribMsg {width:290px;margin-left:5px; margin-top:3px; margin-right:5px; color:#331a00;white-space:normal}
                div.divTxtLayers {display:inline-block; margin-left:5px; margin-right:5px;margin-top:5px; font-weight:bold; width:60px; text-align:right;color:#331a00}
        </style>
</head>
<body>
    <div id="map"></div>
    <!--div style="width:10cm; height: 1cm;background-color:navajowhite">10 cm. test div</div-->
    <button id="clearMessages">clear messages</button>
    <button id="showWorkingLayer">show Leaflet.PM WorkingLayer</button>
    <button id="showEditedFeatures">show editedFeatures</button>
    <button id="updateEditedFeatures">update editedFeatures</button>
    <button id="showAllLayers">show allLayers</button>
    <button id="showObjLayers">show objLayers</button>
</body>
</html>