#!/usr/bin/env node

var request = require('request'),
    cheerio = require('cheerio'),
    host = 'www.pornhub.com',
    root = 'http://' + host
    url = root + '/video?o=ht&cc=jp'

var j = request.jar()
var request = request.defaults({jar: j})

request({url: url, jar: j}, function(error, response, body) {
    var document = {location: {reload: function(a){}}}
    eval(/[^]*<!--([^]*)-->/.exec(body)[1])
    go()
    j.setCookie(request.cookie(document.cookie), root)
    setTimeout(function(){
        request({
            url: url,
            jar: j,
            headers: {
                Host: host,
                Referer: url,
                "User-Agent": "Mozilla/5.0"
            }
        }, function(error, response, body) {
            var $ = cheerio.load(body)
            $.fn.random = function() { return this.eq(Math.floor(Math.random() * this.length)) }  
            $('li.videoblock').random().each(function() {
                console.log(JSON.stringify({
                  link: root + $('a.img', this).attr('href'),
                  img: $('img', this).attr('data-mediumthumb'),
                  title: $('.title', this).text().trim(),
                  views: $('.views', this).text().trim(),
                  rating: $('.rating-container', this).text().trim(),
                  duration: $('.duration', this).text().trim(),
                  hd: $('.hd-thumbnail', this).text().trim(),
                }))
            })
        })
    }, 1000)
})

