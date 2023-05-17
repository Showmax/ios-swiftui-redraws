# Unexpected redrawing in SwiftUI

Blog post: https://showmax.engineering/articles/unexpected-redrawing-in-swiftui

At first sight, I absolutely loved how simple it was to announce changes to SwiftUI views. You just set a value in @Published variables and the view gets reloaded with the fresh value. But soon I realized that there was something I’d missed: the context. In fact, it is described in Apple docs. But it's quite easy to overlook all of the consequences when reading. You understand it better in practice. Let’s have a look at a few examples.

## ObservableObject's objectWillChange

Consider a model that implements ObservableObject with several @Published variables. ObservableObject will automatically synthesize the objectWillChange property. Each SwiftUI view that uses your ObservableObject will subscribe to the objectWillChange changes. Now, if your model changes one of the @Published variables, then SwiftUI will redraw all of the views that use your ObservableObject.

### Example

For full details see our [Github repo](https://github.com/Showmax/ios-swiftui-redraws).

```
class SeriesModel: ObservableObject {
    @Published var title: String = "Tali's Wedding"
    @Published var isMyFavourite: Bool = false
    @Published var episodes: [Episode] = [...]
}
```

This object is shared in several SwiftUI views where each view reads some @Published variable (either directly or indirectly via Binding).

```
struct ContentView: View {
    @StateObject var model = SeriesModel()
    var body: some View {
        VStack(spacing: 16) {
            TitleView(title: model.title)
            MyFavouriteView(model: model)
            EpisodesView(model: model)
        }
    }
}
```

Here’s a full code example: https://github.com/Showmax/ios-swiftui-redraws

Now, if you tap on the heart button, what views will be redrawn?

### What is redrawn? How do I check it out?

To see that, use the hint from Peter Steinberger: add .background(Color.debug) into each view's body. You can also add Self._printChanges().

```
public extension ShapeStyle where Self == Color {
    static var debug: Color {
    #if DEBUG
        return Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    #else
        return Color(.clear)
    #endif
    }
}
```

Now set this debug color as the background for each of your views.

```
TitleView(model: model).background(.debug)
```

### Result

The problem is that all of the views (even “episodes”) got redrawn, despite the fact that we only update the “Add series to favorites” button.

![image1](https://github.com/Showmax/ios-swiftui-redraws/assets/62856/d25cfc79-4789-472c-b82b-b45fa5700b96)


## Is it a problem? …It depends.

Your gut feeling would tell you, it is…bad. Too many redraws. Fix it.

But first, let’s explore the pros and cons of the current approach.

- ➕ Pros
   - simpler code; having all relevant @Published variables inside a single ObservableObject which is very easy to understand
- ➖ Cons
   - too many extra redraws could lead to a lagging UI, extra CPU usage, and battery drain. 

To correctly assess whether the extra redraws are a problem or not, ask yourself two additional questions: do you code for older devices, and do you see any issues when profiling the app with Instruments? In our case, the answer to both questions is “no”, so it's not worth it. Just accept some possible extra redraws and have simpler code.

We would especially recommend verifying view redraws if:
- there is user interaction
- there are timers
- you use the model for multiple screens
- you show lots of items
- you use onReceive to create (Rx/Combine) a subscription that leads to an API call. This could cause extra API calls due to SwiftUI making some extra calls of onReceive. This is nicely described here: https://nalexn.github.io/stranger-things-swiftui-state/

## Solutions

If view redraws hurt the UX or cause other problems, what then?

We have tried several of the options below. They are sorted by their complexity. If you have problems with your current setup, go ahead and try the next, more complex approach.

## #1 Do nothing

- Level: easy
- Accept a few extra redraws and have a simpler codebase. Especially if your view + model are standalone.
- I want to stress that it is perfectly ok to do nothing with redraws. You can always optimize quite easily when it is a real issue.
- Code example https://github.com/Showmax/ios-swiftui-redraws/blob/master/RedrawingExperiment/Example1.swift


## #2 Divide into separate observable objects

- Level: easy
- Split the big problem into two smaller ones.
- That way, SwiftUI will observe two separate objectWillChange properties and won't redraw unrelated views.
- We used this on the Showmax detail screen.
   - The detail header had one ObservableObject.
   - The episode list had another ObservableObject.
- Code example https://github.com/Showmax/ios-swiftui-redraws/blob/master/RedrawingExperiment/Example2.swift

GIF example:

![image2](https://github.com/Showmax/ios-swiftui-redraws/assets/62856/4a16e4e7-d038-43a7-b083-0d666bffd1c9)



## #3 Create observable sub-objects

- Level: moderate
- This is suitable for cases when you have a list of items and each of them can change independently.
- You decouple the component from the original changes. Now the component only works with a subset of the data it actually needs. And, if necessary, you can report changes back to the parent observable object.
- We used this for the rows in the episodes list on the Showmax detail screen.
   - Each row was represented by a separate EpisodeModel: ObservableObject.
   - The parent EpisodesModel had the property @Published var episodes: [EpisodeModel] so when it was set, all episodes were redrawn.
   - But, for example, if one of the episodes started to download and we showed download progress, then only this one row was redrawn. Without a separate ObservableObject, all of the rows would have been be redrawn.
- Code example https://github.com/Showmax/ios-swiftui-redraws/blob/master/RedrawingExperiment/Example3.swift

GIF example: 

![image3](https://github.com/Showmax/ios-swiftui-redraws/assets/62856/16e0c6fb-5a45-4ac7-9639-62cef76cc055)


## #4 Publisher + onReceive + @State

- Level: hard
- This is difficult to read due to the boilerplate code, but it effectively controls what changes in the view.
- The main point is to prevent SwiftUI from being notified by objectWillChange for redrawing.
- You can do it by replacing the @Published variable with CurrentValueSubject
- You will need to notify SwiftUI manually. In the view, you will create an @State var myState property that will hold the data to show in the view. Then use onReceive(model.mySubject) { myState = $0 } to listen for changes and forward data to view.
- We tried this approach for pagination of episodes on Showmax detail screen.
- Code example https://github.com/Showmax/ios-swiftui-redraws/blob/master/RedrawingExperiment/Example4.swift

GIF example: 

![image4](https://github.com/Showmax/ios-swiftui-redraws/assets/62856/7c04dab0-8ca2-45d5-9ea8-f7ba7123ec3c)


## Conclusion

At first, extra view updates look dangerous. It's definitely paying off to keep an eye on them. If they don't happen that much, just let them go and prefer simpler, more readable code. You can always optimize when really needed.



