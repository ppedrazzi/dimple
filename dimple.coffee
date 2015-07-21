
Data = new Mongo.Collection("data")

if Meteor.isClient
    Meteor.startup () ->
        Meteor.call("clearAllData")
        Meteor.call("createData")
        console.log "Client is alive"

    Template.dimple.events
        'click rect': (event) ->
            #Meteor.call("updateData", )
            console.log "clicked", event.currentTarget

    Template.dimple.onRendered () ->
        #works if data is ready fast enough...
        data = Data.find().fetch()
        svg = dimple.newSvg("#chart", 400, 500)
        chart = new (dimple.chart)(svg, data)
        chart.addCategoryAxis 'x', 'year'
        chart.addMeasureAxis 'y', 'value'
        chart.addSeries null, dimple.plot.bar
        chart.draw()
        console.log Data



if Meteor.isServer
    Meteor.startup () ->
        console.log "Server is alive."

    Meteor.methods
        clearAllData: () ->
            Data.remove({})

        createData: () ->
            Data.insert ({year: 1929, value: 50})
            Data.insert ({year: 1944, value: 200})
            Data.insert ({year: 1912, value: 100})
            Data.insert ({year: 1999, value: 220})
            Data.insert ({year: 2010, value: 450})
            Data.insert ({year: 2014, value: 500})
            console.log "Data created."

        updateData: (id) ->
            Data.findOne({_id: id}, {$set: {value: Random.fraction() * 1000}} )
