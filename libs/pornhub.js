#!/usr/bin/env node

var request = require('request'),
    cheerio = require('cheerio'),
    host = 'www.pornhub.com',
    root = 'http://' + host,
    j = request.jar(),
    request = request.defaults({jar: j}),
    attempt = 0,
    categories = { 'Amateur': 3, 'Anal': 35, 'Arab': 98, 'Asian': 1, 'Babe': 5, 'Babysitter': 89, 'BBW': 6, 'BigAss': 4, 'BigDick': 7, 'BigTits': 8, 'Bisexual': 76, 'Blonde': 9, 'Blowjob': 13, 'Bondage': 10, 'Brazilian': 102, 'British': 96, 'Brunette': 11, 'Bukkake': 14, 'Cartoon': 86, 'Casting': 90, 'Celebrity': 12, 'College': 79, 'Compilation': 57, 'Creampie': 15, 'Cumshots': 16, 'Czech': 100, 'DoublePenetration': 72, 'Ebony': 17, 'Euro': 55, 'Exclusive': 115, 'Feet': 93, 'Fetish': 18, 'Fisting': 19, 'ForWomen': 73, 'French': 94, 'Funny': 32, 'Gangbang': 80, 'Gay': 63, 'German': 95, 'Handjob': 20, 'Hardcore': 21, 'HDPorn': 38, 'Hentai': 36, 'Indian': 101, 'Interracial': 25, 'Italian': 97, 'Japanese': 111, 'Korean': 103, 'Latina': 26, 'Lesbian': 27, 'Massage': 78, 'Masturbation': 22, 'Mature': 28, 'MILF': 29, 'Music': 121, 'Orgy': 2, 'Party': 53, 'Pornstar': 30, 'POV': 41, 'Public': 24, 'PussyLicking': 131, 'Reality': 31, 'RedHead': 42, 'RoughSex': 67, 'Russian': 99, 'School': 88, 'Shemale': 83, 'SmallTits': 59, 'Smoking': 91, 'SoloMale': 92, 'Squirt': 69, 'Striptease': 33, 'Teen': 37, 'Threesome': 65, 'Toys': 23, 'Uniforms': 81, 'VerifiedAmateurs': 138, 'Vintage': 43, 'Webcam': 61 },
    category = categories[process.argv[2]],
    url = root + '/video?' + (category? 'c=' + category: 'o=ht&cc=jp')

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

if(process.argv[2] == 'list') {
    console.log(JSON.stringify(categories))
}
else {
    reload()
}

