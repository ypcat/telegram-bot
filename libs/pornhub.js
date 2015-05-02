#!/usr/bin/env node

var request = require('request'),
    cheerio = require('cheerio'),
    host = 'www.pornhub.com',
    root = 'http://' + host,
    url = root + '/video?o=ht&cc=jp',
    j = request.jar(),
    request = request.defaults({jar: j}),
    attempt = 0

function reload() {
    attempt = attempt + 1
    console.error("try loading " + attempt + " times")
    if(attempt > 10) {
        console.error("abort")
        return
    }
    if(document.cookie) {
        console.error("cookie: " + document.cookie)
        j.setCookie(request.cookie(document.cookie), root)
    }
    request({
        url: url,
        jar: j,
        headers: {
            Host: host,
            Referer: url,
            "User-Agent": "Mozilla/5.0"
        }
    }, respond)
}

var document = {location: {reload: reload}, cookie: false}

function respond(error, response, body) {
    if(body.indexOf("Loading ...") > -1) {
        console.error("evaluating guard page")
        eval(/[^]*<!--([^]*)-->/.exec(body)[1])
        go()
    }
    else {
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
    }
}

reload()

