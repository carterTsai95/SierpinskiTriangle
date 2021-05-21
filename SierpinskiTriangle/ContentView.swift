//
//  ContentView.swift
//  SierpinskiTriangle
//
//  Created by Hung-Chun Tsai on 2021-05-19.
//

import SwiftUI

struct ContentView: View {
    @State private var level: Int = 1
    @State private var angle = 0.0
    @State private var duration: Double = 1.0
    @State private var isEditing = false
    let maxLevel = 7
    
    
    var body: some View {
        
        VStack {
            
            TriangleShape(level: level)
                .stroke(Color.red, lineWidth: 1)
                .padding(20)
                .animation(.easeInOut(duration: duration))
                .scaledToFit()
                
            
            HStack(spacing: 40) {
                Stepper("Level \(level)", value: $level, in: 0...maxLevel)
                    .fixedSize()
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            }
        }
        
            
    }
}

struct TriangleShape: Shape {
    
    @State var level: Int
    
    init(level: Int) {
        self.level = level
    }
    
    
    //For this triangle shape, I use the modifier to let the shape scale to fit the size of the screen.
    func getWidthComparasion(width: CGFloat) -> CGFloat {
        return width/(pow(2, CGFloat(level)))
    }
    
    func path(in rect: CGRect) -> Path {
        
        
        /* About the rect coordinator system
            
         Think about this is your whole view
         
         
        minX, minY      midX, minY      maxX, minY
           1              2              3
            * ----------- *  ----------- *
            |             |              |
            |             |              |
 minX, midY4|           5 |            6 | maxX, midY
            * ----------- *  ----------- *
            |             |              |
            |             |              |
           7|           8 |            9 |
            * ----------- *  ----------- *
         minX, maxY      midX, maxY      maxX, maxY
         

         
         */
        
        
        
        let startX = rect.minX
        let startY = rect.maxY
        let width = rect.maxX
        let level = getWidthComparasion(width: width)
        
        func triangle(_ x: CGFloat,_ y: CGFloat, width: CGFloat) {
            var tempWidth = width
            
            let x2 = x + width/2
            let y2 = y - width
            let x3 = x + width
            let y3 = y
            
            
            //Draw the triangle
            path.move(to: CGPoint(x: x, y: y))
            path.addLine(to: CGPoint(x: x2, y: y2))
            path.addLine(to: CGPoint(x: x3, y: y3))
            path.closeSubpath()
            
            
            /*
             The Sierpinski Triangle we can think about It is consist by 3 triangle
             
             1. Bottom left
             2. Bottom right
             3. Top triangle
             
                          /\
                         /  \
                        /____\
                        
                     /\        /\
                    /  \      /  \
                   /____\    /____\
             
             Every time we add one more level, it means in each triangle we will add those three triangles inside the original one.
            
             */
            
            while tempWidth > level {
                tempWidth /= 2
                
                //Draw the bottom left triangle
                triangle(x, y, width: tempWidth)
                
                //Draw the top triangle
                triangle(x + width/4, y - width/2, width: tempWidth)
                
                //Draw the right triangle
                triangle(x + (width/2), y, width: tempWidth)
                
            }
        }
        

        var path = Path()
        
        // Draw the triangle
        triangle(startX, startY, width: width)
    
        return path
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
