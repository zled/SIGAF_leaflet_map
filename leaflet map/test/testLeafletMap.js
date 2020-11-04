export function getServerData(serverAddrAndType) {
	console.log('serverAddrAndType = ',serverAddrAndType);
}
 
export function getMapBounds(toscCenter,toscCenter3003,toscExtents,toscExtents3003) {
    console.log('toscCenter (lat.,lon.) = ', toscCenter);
    console.log('toscCenter (EPSG:3003) = ', toscCenter3003);
    console.log('toscExtents (lat.,lon.) = ',toscExtents);
    console.log('toscExtents (EPSG:3003) = ',toscExtents3003);
}

export function checkGetLayerNamesByType(objLayers) {
    // -- tests objLayers.getLayerNamesByType()

    console.log(
        'objLayers.getLayerNamesByType(\'short\',\'asc\',true)=',
        objLayers.getLayerNamesByType('short', 'asc', true)
    )
    console.log(
        'objLayers.getLayerNamesByType(\'short\',\'asc\',false)=',
        objLayers.getLayerNamesByType('short', 'asc', false)
    )
    console.log(
        'objLayers.getLayerNamesByType(\'short\',\'asc\',null)=',
        objLayers.getLayerNamesByType('short', 'asc', null)
    )
    console.log(
        'objLayers.getLayerNamesByType(\'short\',\'desc\',true)=',
        objLayers.getLayerNamesByType('short', 'desc', true)
    )
    console.log(
        'objLayers.getLayerNamesByType(\'short\',\'desc\',false)=',
        objLayers.getLayerNamesByType('short', 'desc', false)
    )
    console.log(
        'objLayers.getLayerNamesByType(\'short\',\'desc\',null)=',
        objLayers.getLayerNamesByType('short', 'desc', null)
    )
    console.log(
        'objLayers.getLayerNamesByType(\'tiled\',\'desc\',null))=',
        objLayers.getLayerNamesByType('tiled', 'desc', null)
    )

    // -- end tests objLayers.getLayerNamesByType()
}

export function checkFeaturePropertyManager(featurePropertyManager,map) {
    // -- featurePropertyManager test 1: control interface only with testEditedFeature

    var testEditedFeature = {
        "1370": {
            "feature": {
                "type": "Polygon",
                "properties": {
                    "OBJECTID": 4779080,
                    "FOGLIO": "M1262490  ",
                    "PART": "2    ",
                    "SUB": "   ",
                    "PROVINCIA": "PI",
                    "M_DIV": "2009-08-11T08:40:50Z",
                    "M_DFV": "9999-12-30T23:00:00Z",
                    "M_USER": "1310",
                    "M_DM": "2009-08-11T08:40:50Z",
                    "IDTipologia": 700,
                    "DescBreve": "taglio",
                    "DescrizioneTipoPoligono": "Area boscata soggetta a taglio",
                    "AnnoSilvano": 2008,
                    "NOTE": "null",
                    "Shape_Length": 848.3205428546688,
                    "Shape_Area": 37108.846519231796
                },
                "id": "SIGAF_Vista_Poligoni_Attuali.fid--4d0ec2b8_16b32681297_-7dd7"
            },
            "modified": false,
            "drawType": "polygon",
            "options": {
                "crs":
                {
                    "projection": {
                        "_proj": {
                            "oProj": {
                                "projName": "tmerc",
                                "lat0": 0,
                                "long0": 0.15707963267948966,
                                "k0": 0.9996,
                                "x0": 1500000,
                                "y0": 0,
                                "ellps": "intl",
                                "datum_params": [-104.1, -49.1, -9.9, 0.971, -2.917, 0.714, -11.68],
                                "units": "m",
                                "no_defs": true,
                                "axis": "enu",
                                "names": ["Transverse_Mercator", "Transverse Mercator", "tmerc"],
                                "a": 6378388, "b": 6356911.9461279465,
                                "rf": 297,
                                "es": 0.006722670022333227,
                                "e": 0.08199188997902919,
                                "ep2": 0.006768170197224155,
                                "datum": {
                                    "datum_type": 2,
                                    "datum_params": [-104.1, -49.1, -9.9, 0.000004707540843573594, -0.000014142015077965163, 0.000003461569683122087, 0.99998832],
                                    "a": 6378388,
                                    "b": 6356911.9461279465,
                                    "es": 0.006722670022333227,
                                    "ep2": 0.006768170197224155
                                },
                                "en": [0.9983172080560443, 0.005039878078377481, 0.000021180853866295737, 1.1075837467602343e-7, 6.283155036917403e-10],
                                "ml0": 0
                            }
                        },
                        "_initHooksCalled": true
                    },
                    "options": {},
                    "code": "EPSG:3003",
                    "transformation": { "_a": 1, "_b": 0, "_c": -1, "_d": 0 },
                    "infinite": true,
                    "_initHooksCalled": true
                }
            }
        },
        "modified": false
    };
    // -- featurePropertyManager end test 1: ---------------------------------------------

    setTimeout(function(){featurePropertyManager(testEditedFeature['1370'].feature,map.getCenter())},5000);    
}

export function checkConfirmPopup() {
    confirmPopup('questo oggetto è stato modificato. Confermi la cancellazione ?',null,map.getCenter());
}

export function checkISOLocalDateTime() {
	console.log ('new Date().toISOLocalDateTime() = ',new Date().toISOLocalDateTime());
	var d= new Date(2014,9,14,14,12,25,156);
	console.log('d = ', d);
	console.log('d.toISOLocalDateTime() = ', d.toISOLocalDateTime());
}

export function checkFeatureUtils (featureUtils,objCrs){

// -- test projectBasicObjLatLng()

	var basicLatLng=[
		{"lat":43.79488907226601,"lng":8.838500976562502},
		{"lat":43.87017822557581,"lng":9.074707031250002},
		{"lat":43.82660134505382,"lng":9.371337890625002},
		{"lat":43.58834891179792,"lng":9.470214843750002},
		{"lat":43.4249985081581,"lng":9.310913085937502},
		{"lat":43.48481212891603,"lng":8.964843750000002},
		{"lat":43.671844983221604,"lng":8.739624023437502}
	],
	basicProjected = featureUtils.projectBasicObjLatLng(basicLatLng,L.CRS.EPSG3003);

	console.log(
        'test projectBasicObjLatLng()\n',
        'input array=', 
        basicLatLng,
        'result=',
        basicProjected
    );

// -- test convertNestedLatLng(latLngArray,objCrs)
            
	var latLngArray=[
		[   {"lat":43.39706523932025,"lng":8.613281250000002},
			{"lat":43.297198404646366,"lng":8.756103515625002},
			{"lat":43.25320494908846,"lng":9.014282226562502},
			{"lat":43.37710501700073,"lng":9.343872070312502},
			{"lat":43.50872101129687,"lng":9.552612304687502},
			{"lat":43.70362249839005,"lng":9.563598632812502},
			{"lat":43.81471121600004,"lng":9.481201171875002},
			{"lat":43.88205730390537,"lng":9.299926757812502},
			{"lat":43.858296779161854,"lng":8.981323242187502},
			{"lat":43.69965122967144,"lng":8.767089843750002},
			{"lat":43.568451798812205,"lng":8.668212890625002}
		],[
			{"lat":43.54456658436358,"lng":8.805541992187502},
			{"lat":43.432977075795606,"lng":8.827514648437502},
			{"lat":43.35713822211053,"lng":8.915405273437502},
			{"lat":43.39706523932025,"lng":9.096679687500002},
			{"lat":43.48082639482503,"lng":9.146118164062502},
			{"lat":43.572431747409745,"lng":9.063720703125002},
			{"lat":43.62017061618992,"lng":8.909912109375002}
		],[
			{"lat":43.691707903073805,"lng":9.102172851562502},
			{"lat":43.62414714566807,"lng":9.190063476562502},
			{"lat":43.600284023536325,"lng":9.321899414062502},
			{"lat":43.691707903073805,"lng":9.365844726562502},
			{"lat":43.771093817756515,"lng":9.255981445312502},
			{"lat":43.771093817756515,"lng":9.118652343750002}]
	],
	latLngArray1=[
		[   {"lat":43.39706523932025,"lng":8.613281250000002},
			{"lat":43.297198404646366,"lng":8.756103515625002},
			{"lat":43.25320494908846,"lng":9.014282226562502},
			{"lat":43.37710501700073,"lng":9.343872070312502},
			{"lat":43.50872101129687,"lng":9.552612304687502},
			{"lat":43.70362249839005,"lng":9.563598632812502},
			{"lat":43.81471121600004,"lng":9.481201171875002},
			{"lat":43.88205730390537,"lng":9.299926757812502},
			{"lat":43.858296779161854,"lng":8.981323242187502},
			{"lat":43.69965122967144,"lng":8.767089843750002},
			{"lat":43.568451798812205,"lng":8.668212890625002}
		],[
			{"lat":43.54456658436358,"lng":8.805541992187502},
			{"lat":43.432977075795606,"lng":8.827514648437502}, 
			{"lat":43.35713822211053,"lng":8.915405273437502},
			{"lat":43.39706523932025,"lng":9.096679687500002},
			{"lat":43.48082639482503,"lng":9.146118164062502},
			{"lat":43.572431747409745,"lng":9.063720703125002},
			{"lat":43.62017061618992,"lng":8.909912109375002}
		],[
			{"lat":43.691707903073805,"lng":9.102172851562502},
			{"lat":43.62414714566807,"lng":9.190063476562502},
			{"lat":43.600284023536325,"lng":9.321899414062502},
			{"lat":43.691707903073805,"lng":9.365844726562502},
			{"lat":43.771093817756515,"lng":9.255981445312502},
			{"lat":43.771093817756515,"lng":9.118632343750002}] // {"lat":43.771093817756515,"lng":9.118652343750002}
	],
    featureProjected = featureUtils.projectNestedLatLng(latLngArray,'polygon',objCrs),

	// -- test compareNestedCoordsArray()
                    
	t0= new Date().valueOf(),
		rc = featureUtils.compareNestedCoordsArray(latLngArray,latLngArray),
		t1 = new Date().valueOf() - t0;
	console.log(
        'compareNestedCoordsArray(latLngArray,latLngArray)=',
        rc,
        '(' + String(t1) + ' msec.)'
    );
	t0 = new Date().valueOf();
	rc = featureUtils.compareNestedCoordsArray(latLngArray,latLngArray1);
	t1 = new Date().valueOf() - t0;
	console.log(
        'compareNestedCoordsArray(latLngArray,latLngArray1)=',
        rc,
        '(' + String(t1) + ' msec.)'
    );
   


	latLngArray=[
		[
			[   {"lat":43.72744458647466,"lng":8.602294921875002},
				{"lat":43.35713822211053,"lng":8.635253906250002},
				{"lat":43.32924466230126,"lng":8.687820201029606},
				{"lat":43.4728541377797,"lng":8.904418945312502},
				{"lat":43.67581809328341,"lng":8.789062500000002}
			]
		],
		[
			[
				{"lat":43.81462317679459,"lng":8.749524330784103},
				{"lat":43.715534726205114,"lng":8.898925781250002},
				{"lat":43.695679697898825,"lng":9.354858398437502},
				{"lat":43.81902931464264,"lng":9.715978410440885},
				{"lat":43.96119063892027,"lng":9.613037109375002},
				{"lat":43.94537239244211,"lng":8.970336914062502}
			]
		],
		[
			[
				{"lat":43.21428422069659,"lng":8.904466785499462},
				{"lat":43.12103377575541,"lng":9.080200195312502},
				{"lat":43.113014204188914,"lng":9.503173828125},
				{"lat":43.389996529590114,"lng":9.691241501063603},
				{"lat":43.48082639482503,"lng":9.382324218750002},
				{"lat":43.45291889355465,"lng":9.162597656250002},
				{"lat":43.32118142926663,"lng":9.025268554687502}
			],
			[
				{"lat":43.80678314779554,"lng":8.931884765625002},
				{"lat":43.76315996157264,"lng":9.014282226562502},
				{"lat":43.78695837311561,"lng":9.140625000000002},
				{"lat":43.862257524417934,"lng":9.096679687500002},
				{"lat":43.874138181474734,"lng":8.992309570312502}
			],
			[
				{"lat":43.33316939281735,"lng":9.261474609375002},
				{"lat":43.21318330073888,"lng":9.327392578125002},
				{"lat":43.24120121425791,"lng":9.486694335937502},
				{"lat":43.345154990451135,"lng":9.503173828125},
				{"lat":43.389081939117496,"lng":9.365844726562502}
			],
			[
				{"lat":43.8899753738369,"lng":9.261474609375002},
				{"lat":43.771093817756515,"lng":9.283447265625002},
				{"lat":43.76315996157264,"lng":9.4207763671875},
				{"lat":43.89789239125797,"lng":9.4207763671875}
			]
		]
	];
	featureProjected = featureUtils.projectNestedLatLng(latLngArray,'polygon',objCrs);

	console.log(
        'test featureUtils.projectNestedLatLng()\n',
        'input array=',
        latLngArray,
        'result=',
        featureProjected
    );
}
