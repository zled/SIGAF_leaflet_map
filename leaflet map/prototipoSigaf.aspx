<!--%@ Page Language="C#"  EnableViewState="true" AutoEventWireup="true"  Inherits="MSDN.SessionPage"%-->
<%@ Page Language="C#"  EnableViewState="true" AutoEventWireup="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <title>Catasto WMS con Leaflet</title>

    <meta name="viewport" content="initial-scale=1.0, user-scalable=no, width=device-width">

    <script runat="server">
//protected void Page_Load(object sender, EventArgs e)
//{
//    // -- controllo se siamo in sessione (da migliorare verificando  user e password in tabella Utente)

//    // -- debug per permettere di accedere alla pagina anche se non autenticati

//    Session["user"] = "leo";
//    Session["pwd"] = "miaPass";

//    int counter = 0;
//    String str;
//    for (int k = 1; k <= Session.Count(); k++)
//    {
//        str = Session.Key(k);
//        if (str == "user" || str == "pwd") counter++;
//        if (counter == 2) break;
//    }
//    if (counter == 2) Response.Write("autenticato");
//    else
//    {
//        Response.Write("non autenticato");
//        Response.End();
//    }
//}
    </script>

    <link rel="stylesheet" href="http://cdn.leafletjs.com/leaflet/v1.3.4/leaflet.css" />

    <script src="http://cdn.leafletjs.com/leaflet/v1.3.4/leaflet.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/proj4js/2.5.0/proj4.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/proj4leaflet/1.0.2/proj4leaflet.js"></script>

    <script type="text/javascript">

    (function () {
        //var extent = [1554746.1124763484, 4686710.11317738, 1771653.1243634056, 4924787.538759868]; // tuscany region extents


        var toscExtents = [[42.155259, 9.398804], [44.523927, 12.650757]],
            toscCenter = [(toscExtents[1][0] + toscExtents[0][0]) / 2.0, (toscExtents[1][1] + toscExtents[0][1]) / 2.0],
            clientAddr = "<% =Request.ServerVariables["REMOTE_ADDR"]%>";
            

        //console.log(toscCenter);

        if (clientAddr.length > 6) clientAddr = clientAddr.substr(0, 7);

        window.addEventListener("load", initMap);

        function initMap() {
            //var urlGeoServerArtea = ["192.168"].indexOf(clientAddr) >= 0 || clientAddr.length < 7 ? "http://192.168.60.21:8080/geoserver" : "http://159.213.81.199/geoserver",
            var urlGeoServerArtea = "http://159.213.81.199/geoserver",
                urlGeoServerArteaWMS = "/ARTEA/wms",
                urlGeoServerArteaTms = "/gwc/service/tms/1.0.0";

            startWebGis();

            function startWebGis() {
                urlGeoServerArteaWMS = urlGeoServerArtea + urlGeoServerArteaWMS;
                urlGeoServerArteaTms = urlGeoServerArtea + urlGeoServerArteaTms;

                var crs_3003 = new L.Proj.CRS(
                    "EPSG:3003",
                    "+proj=tmerc +lat_0=0 +lon_0=9 +k=0.9996 +x_0=1500000 +y_0=0 +ellps=intl +towgs84=-104.1,-49.1,-9.9,0.971,-2.917,0.714,-11.68 +units=m +no_defs",
                    {}
                );

                var obSource = new proj4.Proj('EPSG:4326'),
                    obDest = new proj4.Proj('EPSG:3003'),
                    obResult = new proj4.toPoint([toscCenter[1],toscCenter[0]]);
                //alert(JSON.stringify(proj4(obSource, obDest, obResult)));

                var map =
                L.map('map', {
                    center: toscCenter,
                    //zoom: 9,
                    minZoom: 8,
                    maxZoom:21
                });

                map.fitBounds(toscExtents);

                var poligoniSigaf = L.tileLayer(urlGeoServerArteaTms + "/ARTEA:SIGAF_Vista_Poligoni_Attuali@EPSG:900913@png/{z}/{x}/{-y}.png", {
                    layers: ['ARTEA:SIGAF_Vista_Poligoni_Attuali'],
                    minZoom: 15,
                    maxZoom: 21,
                    tms: true,
                    crs: crs_3003,
                    updateWhenIdle: true
                }).addTo(map);

                var particelle = L.tileLayer(urlGeoServerArteaTms + "/ARTEA:TOSC_Particelle@EPSG:900913@png/{z}/{x}/{-y}.png", {
                    layers: ['ARTEA:TOSC_Particelle'],
                    minZoom: 17,
                    maxZoom: 21,
                    tms: true,
                    crs: crs_3003,
                    updateWhenIdle: true
                }).addTo(map);

                var fogli = L.tileLayer(urlGeoServerArteaTms + "/ARTEA:TOSC_BordiFoglio@EPSG:900913@png/{z}/{x}/{-y}.png", {
                    layers: ['ARTEA:TOSC_BordiFoglio'],
                    minZoom: 14,
                    maxZoom: 16,
                    tms: true,
                    crs: crs_3003,
                    //updateWhenIdle: true
                }).addTo(map);

                var comuni = L.tileLayer(urlGeoServerArteaTms + "/ARTEA:TOSC_Comuni@EPSG:900913@png/{z}/{x}/{-y}.png", {
                    layers: ['ARTEA:Tosc_Comuni'],
                    maxZoom: 12,
                    tms: true,
                    crs: crs_3003,
                    attribution: false,
                    transparent: true,
                    updateWhenIdle: true
                }).addTo(map);

                var OSM_basemap = L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png', {
                    attribution: '&copy; <a href="http://osm.org/copyright" target="_blank">OpenStreetMap</a>',
                    maxZoom: 21
                }).addTo(map);

                var mapboxOrtofoto = L.tileLayer('https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token={accessToken}', {
                    attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="http://mapbox.com">Mapbox</a>',
                    minZoom: 14,
                    maxZoom: 21,
                    id: 'mapbox.satellite',
                    accessToken: 'pk.eyJ1IjoiemxlZDU1IiwiYSI6ImNqdGxnMWVwbjA3dTE0OW9qNmhibjF1aDEifQ.xdbVsuJslfBtPai_Na04vw',
                    //updateWhenIdle: true
                }).addTo(map);

                var googleMap = L.tileLayer('http://www.google.cn/maps/vt?lyrs=s@189&gl=cn&x={x}&y={y}&z={z}', {
                    attribution: 'google',
                    minZoom: 14,
                    maxZoom: 21,
                    //updateWhenIdle: true
                }).addTo(map);

                //ARTEA:rt_ofc.5k16.32bit
                var ortofoto2016 = L.tileLayer(urlGeoServerArteaTms + "/ARTEA:rt_ofc.5k16.32bit@EPSG:900913@jpeg/{z}/{x}/{-y}.jpeg", {
                    map: 'owsofc',
                    layers: ['rt_ofc.5k16.32bit'],
                    minZoom: 16,
                    maxZoom: 21,
                    tms: true,
                    crs: crs_3003,
                    attribution: 'AGEA|OFC 2016 5k',
                    transparent: true,
                    //updateWhenIdle: true
                }).addTo(map);

                var baseMaps = {
                    "ortofoto AGEA 2016": ortofoto2016,
                    "Google": googleMap,
                    "MapBox ortofoto": mapboxOrtofoto,
                    "OpenStreet Map": OSM_basemap,
                };
                var overlayMaps = {
                    "comuni": comuni,
                    "fogli": fogli,
                    "particelle": particelle,
                    "poligoni SIGAF": poligoniSigaf
                };
                L.control.layers(baseMaps, overlayMaps, {
                    collapsed: true
                }).addTo(map);

                var popup = L.popup({ maxWidth: 500 });

                function meterWidthInPixels() {
                    var px;
                    var div = document.createElement("div");
                    div.style.cssText = "position: absolute;  left: -100%;  top: -100%;  width: 100cm;";
                    document.body.appendChild(div);
                    var px = div.offsetWidth;
                    document.body.removeChild(div);
                    return px;
                }
                function getScaleFromScaleControl(scaleControl) {
                    var pxStringWidth = scaleControl._mScale.style.width,
                        widthString = scaleControl._mScale.innerHTML,
                        width = widthString.endsWith("km") ? parseInt(widthString) * 1000 : parseInt(widthString),
                        pxWidth = parseInt(pxStringWidth);
                    return width * meterWidthInPixels()/pxWidth;
                }
                function onMapClick(e) {
                    var dotPitch = 1 / meterWidthInPixels() * 1000;
                    popup
                        .setLatLng(e.latlng)
                        .setContent(
                            "You clicked the map at " + e.latlng.toString() + "<br/>Current zoom is " + String(map.getZoom()) +
                            "<br/>Current calculated scale is " + String(getScaleFromScaleControl(scaleControl)) + 
                            "<br/>on this computer dot pitch is  " + String(dotPitch) + " mm."
                        )
                        .openOn(map);
                }
                map.on('click', onMapClick);

                L.Control.zoomAndScaleInfo = L.Control.extend({
                    _zoom: null,
                    _scale: null,
                    _zoomValue: null,
                    _scaleValue: null,
                    setZoomAndScale: function(){
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

                L.control.zoomAndScaleInfo = function (opts) {
                    return new L.Control.zoomAndScaleInfo(opts);
                }

                var zoomAndScaleInfo = L.control.zoomAndScaleInfo(
                    { position: 'bottomleft'}
                    ).addTo(map);

                var scaleOptions = {
                    imperial: false
                }
                var scaleControl = L.control.scale(scaleOptions).addTo(map);
                map.on('zoomend', function (e) {
                    zoomAndScaleInfo.setZoomAndScale();
                })
                scaleControl._container.style.marginLeft = "10px";
            }
        }
    })();

    </script>
<style>
            html, body {
                height: 100%;
                font-family: arial;
                font-size: 12px;
            }

            #map {
                height: 768px;
                width: 1024px;
            }

            @media (max-width: 600px) {
                .foothead, #map {
                    width: 100%;
                }

            }
            div.ScaleInfoLabel {display:inline-block;width:50px;text-align:right;margin-right:3px;background-color:rgba(51, 159, 163, 0.52); color:blue; margin-bottom:2px;padding-right:3px}
            div.ScaleInfoValue {display:inline-block;width:50px; color:red}

    </style>
</head>
<body>
    <div id="map"></div>
    <!--div style="width:10cm; height: 1cm;background-color:navajowhite">10 cm.</div-->
</body>
</html>