//solo funciona llamo a la funcion
//$(document).ready(function() {


var mapa;
var markers = [];


/**
 *	Por algun motivo, cuando uso el callback para lanzar inicarMapa, algunas veces funciona otras no.
 * 	Con window.onload siempre funciona.
 *  @param  {[type]} ) {	setMapOnAll(mapa);} [description]
 *  @return {[type]}   [description]
 */
window.onload = function() {
	iniciarMapa();
};


var iniciarMapa = (function () {

	var cccSanLorenzo = {
							lat: -26.8338135,
							lng: -65.2052511
						};

	mapa = new google.maps.Map(document.getElementById("mapa"), {
		zoom: 13,
		center: cccSanLorenzo,
		rotateControl: true,
		mapTypeControl: true,
		mapTypeControlOptions: {
			style: google.maps.MapTypeControlStyle.HORIZONTAL_BAR,
			mapTypeIds: [
				google.maps.MapTypeId.ROADMAP,
				google.maps.MapTypeId.TERRAIN,
				google.maps.MapTypeId.SATELLITE,
				google.maps.MapTypeId.HYBRID
			]
		}
	});
	addMarker(cccSanLorenzo, "ccc");

	setMarkersJSON();

	// This event listener will call addMarker() when the map is clicked.
	//INTERESANTE AÑADE AL HACER CLICK
	//map.addListener("click", function(event) {
		//addMarker(event.latLng);
	//});
});


/** 
 *	Adds a marker to the map and push to the array.
 * 	@param  {[type]} ) {	setMapOnAll(mapa);} [description]
 *  @return {[type]}   [description]
 */
var addMarker = (function (punto, info) {

	if (info == "ccc") {
		var marker = new google.maps.Marker({
			position: punto,
			map: mapa,
			icon: lookIconoCCC()
		});

		var infowindow = new google.maps.InfoWindow({
			content: "<h3>CCC -  San Lorenzo 496</h3>"
		});
	}
	else {
		var marker = new google.maps.Marker({
			position: punto,
			map: mapa,
			icon: lookIcono()
		});

		var infowindow = new google.maps.InfoWindow({
			content: info
		});
	}
	



	marker.addListener('click', function() {
		//infoWindow.setContent("<img src='/home/pablo/Proyectos/Web/PFW/mapa_abonados/back_end/uhfapp/jpg/clie_199691.jpg'>");
		infowindow.open(mapa, marker);
	});

	markers.push(marker);
});


var lookIconoCCC = (function() {
	var url = "http://icons.iconarchive.com/icons/icons-land/vista-map-markers/16/Map-Marker-Marker-Outside-Pink-icon.png";
	var icono = {
			url: url,
			size: new google.maps.Size(15, 15),
			scaledSize: new google.maps.Size(15, 15),
			anchor: new google.maps.Point(15, 15)
		};
	return icono;
});


var lookIcono = (function() {

	//var url = "https://www.google.com/mapfiles/marker_green.png";
	//var url = "https://www.google.com/mapfiles/marker.png",
	//var url = "https://www.google.com/mapfiles/marker_yellow.png";

	//var url = "http://icons.iconarchive.com/icons/icons-land/vista-map-markers/16/Map-Marker-Bubble-Chartreuse-icon.png";
	//var url = "http://icons.iconarchive.com/icons/icons-land/vista-map-markers/16/Map-Marker-Marker-Outside-Chartreuse-icon.png";
	//var url = "http://icons.iconarchive.com/icons/icons-land/vista-map-markers/16/Map-Marker-Marker-Inside-Chartreuse-icon.png";

	//var url = "http://icons.iconarchive.com/icons/icons-land/vista-map-markers/16/Map-Marker-Bubble-Pink-icon.png";
	//var url = "http://icons.iconarchive.com/icons/icons-land/vista-map-markers/16/Map-Marker-Marker-Inside-Pink-icon.png";
	//var url = "http://icons.iconarchive.com/icons/icons-land/vista-map-markers/16/Map-Marker-Marker-Outside-Pink-icon.png";

	//var url = "http://icons.iconarchive.com/icons/icons-land/vista-map-markers/16/Map-Marker-Bubble-Azure-icon.png";
	var url = "http://icons.iconarchive.com/icons/icons-land/vista-map-markers/16/Map-Marker-Marker-Outside-Azure-icon.png";
	//var url = "http://icons.iconarchive.com/icons/icons-land/vista-map-markers/16/Map-Marker-Marker-Inside-Azure-icon.png";
	
	//var url = "http://icons.iconarchive.com/icons/glyphish/glyphish/16/07-map-marker-icon.png";

	var icono = {
			url: url,
			size: new google.maps.Size(15, 15),
			scaledSize: new google.maps.Size(15, 15),
			anchor: new google.maps.Point(15, 15)
		};

	return icono;

});


/**
 * Sets the map on all markers in the array.
 * @param  {[type]} ) {	setMapOnAll(mapa);} [description]
 * @return {[type]}   [description]
 */
var setMapOnAll = (function (mapa) {
	for (var i = 0; i < markers.length; i++) {
		markers[i].setMap(mapa);
	}
});


/**
 * Removes the markers from the map, but keeps them in the array.
 * @param  {[type]} ) {	setMapOnAll(mapa);} [description]
 * @return {[type]}   [description]
 */
var clearMarkers = (function () {
	setMapOnAll(null);
});


/**
 *	Shows any markers currently in the array.
 * 	@param  {[type]} ) {	setMapOnAll(mapa);} [description]
 * 	@return {[type]}   [description]
 */
var showMarkers = (function () {
	setMapOnAll(mapa);
});


/**
 *	Deletes all markers in the array by removing references to them.
 * 	@param  {Array}  ) {	clearMarkers();	markers [description]
 * 	@return {[type]}   [description]
 */
var deleteMarkers = (function () {
	clearMarkers();
	markers = [];
});


var setMarkersArchivoJSON = (function() {
	var i;
	var data;

	var json = (function () {
		var json = null;
		$.ajax({
			async: false,
			global: false,
			url: "js/hotels.json",
			dataType: "json",
			success: function (data) {
				json = data;
			}
		});
		return json;
	})();

	length = json.length;
	for (i = 0; i < length; i++) {
		data = json[i];
		latLng = new google.maps.LatLng(data.lat, data.lng);

		//alert(data.lat);
		//alert(data.lng);

		punto = {lat: data.lat, lng: data.lng};

		addMarker(punto);
	}
});


var setMarkersJSON = (function () {
	var i;
	var data;

	var json = (function () {
		var json = null;

		$.ajax({
			async: false,
			global: false,
			type: "POST",
			//url: "arr2.php",
			url: "php/bd_a_json.php",
			dataType: "json",
			success: function (data) {
				json = data;
			}
		});

		return json;
	})();

	if(json != null ) {

		length = json.length;
	//alert(length);
		for (i = 0; i < length; i++) {

			data = json[i];
			latLng = new google.maps.LatLng(data.lat, data.lng);

			//alert(data.lat);
			//alert(data.lng);

			punto = {lat: data.lat, lng: data.lng};
			numero_abonado = "<h3>Número Abonado: " + data.numero_abonado + "</h3><br><br>";
			foto = "<br><img src='/PFW/mapa_abonados/back_end/uhfapp/jpg/clie_231475.jpg'>";
			foto = "<br><img src='" + data.foto + "'>";


			info =  numero_abonado + foto; 

			//alert(info);

			addMarker(punto,info);
		}
	}
});