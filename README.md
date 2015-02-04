
ARGraphs
===========

[![Build Status](https://travis-ci.org/AlexmReynolds/ARGraphs.svg?branch=master)](https://travis-ci.org/AlexmReynolds/ARGraphs)

[![Version](https://img.shields.io/cocoapods/v/ARGraphs.svg?style=flat)](http://cocoadocs.org/docsets/ARGraphs)
[![License](https://img.shields.io/cocoapods/l/ARGraphs.svg?style=flat)](http://cocoadocs.org/docsets/ARGraphs)
[![Platform](https://img.shields.io/cocoapods/p/ARGraphs.svg?style=flat)](http://cocoadocs.org/docsets/ARGraphs)

Fun graphs for iOS. 

![demo](demo.gif)

All Charts respond to the Appearance selector so you can set App wide settings in App Did finish launching.

```objc
	//Line Graph
	[[ARLineGraph appearance] setUseBackgroundGradient:NO];
    [[ARLineGraph appearance] setLabelColor:[UIColor redColor]];
    [[ARLineGraph appearance] setTintColor:[UIColor blueColor]];
    [[ARLineGraph appearance] setLineColor:[UIColor redColor]];
    [[ARLineGraph appearance] setShowXLegend:YES];
    [[ARLineGraph appearance] setShowXLegendValues:NO];
    [[ARLineGraph appearance] setShowYLegend:YES];
    [[ARLineGraph appearance] setShowYLegendValues:YES];
    [[ARLineGraph appearance] setNormalizeXValues:YES];
    [[ARLineGraph appearance] setShowDots:NO];
    [[ARLineGraph appearance] setShowMeanLine:NO];
    [[ARLineGraph appearance] setShowMinMaxLines:NO];
    [[ARLineGraph appearance] setShouldFill:NO];
    [[ARLineGraph appearance] setShouldSmooth:NO];
    [[ARLineGraph appearance] setAnimationDuration:4.0];

    //Pie Chart
    [[ARPieChart appearance] setUseBackgroundGradient:NO];
    [[ARPieChart appearance] setLabelColor:[UIColor redColor]];
	[[ARPieChart appearance] setSliceGutterWidth:2.0];
    [[ARPieChart appearance] setInnerRadiusPercent:0.4];
    [[ARPieChart appearance] setInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
    [[ARPieChart appearance] setAnimationDuration:4.0];

    //Circle Graph
    [[ARCircleGraph appearance] setLabelColor:[UIColor redColor]];
    [[ARCircleGraph appearance] setRingColor:[UIColor redColor]];
    [[ARCircleGraph appearance] setMinColor:[UIColor yellowColor]];
    [[ARCircleGraph appearance] setMaxColor:[UIColor redColor]];
    [[ARCircleGraph appearance] setLineWidth:4.0];
    [[ARCircleGraph appearance] setAnimationDuration:4.0];
```    
    
## ARLineGraph

### Customizing


## ARPieChart
 ARPieChart represents an array of data in a pie format. The data array can either be an array of datapoints or an array of arrays of datapoint. Simple datapoints like agregated data could be like $450 spent on fast food. Complex data could be each Fast food transaction and the chart will sum up the array.
 ```objc
 [pieChart setDataPoints:@[]]
 ```
 
### Customizing
 The pie uses a background gradient which is a lighter and darker color of the view's tintColor. The gradient is applied by default. 
 ```pieChart.useBackgroundGradient = NO;``` will remove the gradient and you can set a background color. Background color is clear by default.
 
 Labels on the chart default to white but can be set. This will set the color of the title, subtitle and pie section labels.
 
 ```objc
 pieChart.labelColor = [UIColor redColor];
 ```
 
 The tintColor of the view will set the gradient tint and also set the default Pie Tint unless you have implemented the delegate method for customized colors;
 
 ```objc
 pieChart.tintColor = [UIColor greenColor];
 ```
 
 Gutters can be applied to add space between each slice.
 
 ```pieChart.sliceGutterWidth = 4.0``` will space the slices 4pts from the true center;
 
 An Inner radius or donut hole can be applied. The innerRadiusPercent is a percentage of the total radius.
 
 ```pieChart.innerRadiusPercent = 0.4;``` will cut a hole that is 40% the radius of the chart.
 
 Title and Subtitles for PieChart are set via delegate methods. These are called on `[pieChart reloadData];`.
 To set the charts title add the following delegate method and return your title
 
 ```objc
    - (NSString *)titleForPieChart:(ARPieChart *)chart 
    {
        return @"Transactions";
    }
```

 To set the charts SubTitle add the following delegate method and return your subtitle
 
 ```objc
    - (NSString *)subTitleForPieChart:(ARPieChart *)chart
    {
        return @"$1000";
    }
```

To label each slice return your slice title in the following method

```objc
    - (NSString *)ARPieChart:(ARPieChart *)chart titleForPieIndex:(NSUInteger)index
    {
        switch(index){
            case 0:
                return @"Fastfood";
            break;
        };
    }
```

You can customize the color of each slice by passing an array of CGColorRefs in the following method.

```objc
    - (UIColor *)ARPieChart:(ARPieChart *)chart colorForSliceAtIndex:(NSUInteger)index
    {
        return @[(id)[UIColor redColor].CGColor, (id)[UIColor greenColor].CGColor]];
    }
```
## ARCircleGraph
ARCircleGraph represents only 1 piece of data and is numeric in nature. This is great for things like number of steps taken in a day or number of likes or number of views.
### Customizing
The color of the inner label can be set. It defaults to dark gray;
 
 ```objc
 circleGraph.labelColor = [UIColor greenColor];
 ```
 
The color of the ring used to express the percent of total can be colored by setting ringColor.
 
 ```objc
 circleGraph.ringColor = [UIColor greenColor];
 ```
 
The ring can also be colored by setting minColor and maxColor. This will take the percent you set and make the ring a color that percentage between min and max colors. Say your range is 0 to 100 miles an hour. You might set minColor to green and maxColor to red. At 80% the ring could be a mix of green red.
 
 ```objc
 circleGraph.minColor = [UIColor greenColor];
 circleGraph.maxColor = [UIColor redColor];

 ```

The width of the ring is set via lineWidth. The view will resize the label to fit inside the ring width 
 ```objc
 circleGraph.lineWidth = 8.0;

 ```
 
 The value you want to show is set via the value property. If animating then it will animate from 0 to this value. If your value is large it is a good idea to set valueFormat so that you can have 100k represent 100,000 and make the animation less crazy
 ```objc
 circleGraph.value = 100.0;

 ```
 
 The value you want to set may be 100,000 so instead you can set a format so it would say 100 K when you set value to 100. 
 ```objc
 circleGraph.valueFormat = @"%.02f K";

 ```