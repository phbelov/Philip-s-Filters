import Foundation
import UIKit

public class Filter {
    // Intensity has a default value of 0 : if the intenisty is not set then the filter is not applied
    var intensity : Int = 0
    
    // Default Initializer
    public init() {
    }
    public init(intensity : Int) {
        self.intensity = intensity
    }

    public func processPixel(pixel: Pixel) -> Pixel {
        return pixel
    }
}

// Brightness
public class Brightness : Filter {
    
    override public func processPixel(var pixel: Pixel) -> Pixel {
        let formula = self.intensity * 128 / 100
        pixel.red = clamp(Int(pixel.red) + formula)
        pixel.blue = clamp(Int(pixel.blue) + formula)
        pixel.green = clamp(Int(pixel.green) + formula)
        return pixel
    }
}

// Contrast
public class Contrast : Filter {
    
    override public func processPixel(var pixel: Pixel) -> Pixel {
        pixel.red = componentValue(pixel.red)
        pixel.green = componentValue(pixel.green)
        pixel.blue = componentValue(pixel.blue)
        return pixel
    }
    private func componentValue(channel : UInt8) -> UInt8 {
            var formula = 0
        
            // Depending on whether the user wants to increase or decrease contrast we apply different formulas to pixel
            if self.intensity > 0 {
                formula = (Int(channel) * 100 - 128 * self.intensity) / (100 - self.intensity + 1)
            } else {
                formula = (Int(channel) * (100 - abs(self.intensity)) + 128 * abs(self.intensity)) / 100
            }
            return UInt8(max(0, min(255, formula)))
    }
}

// Grayscale
public class Grayscale : Filter {
    
//    override public init(intensity : Int) {
//        super.init()
//        self.intensity = 0
//    }
    
    override public func processPixel(var pixel: Pixel) -> Pixel {
        let average = (Int(pixel.red) + Int(pixel.green) + Int(pixel.blue)) / 3
        
        // Assigning Each Component of the Pixel to the Average Value (aValue)
        let aValue = clamp(average * 2)
        pixel.red = aValue
        pixel.green = aValue
        pixel.blue = aValue
        
        return pixel
    }
    
}

// Color Balance
public class ColorBalance : Filter {
    
    // Default Color Channel to Modify is Red
    var channel : ColorChannel = .Red
    public init (intensity : Int, channel : ColorChannel) {
        super.init()
        self.intensity = intensity
        self.channel = channel
    }
    
    override public func processPixel(var pixel: Pixel) -> Pixel {
        
        // Processing a pixel component depends on a color channel that was provided by a user
        switch(self.channel) {
        case .Red :
            pixel.red = clamp(Int(pixel.red) + self.intensity * 128 / 100)
            break
        case .Green :
            pixel.green = clamp(Int(pixel.green) + self.intensity * 128 / 100)
            break
        case .Blue :
            pixel.blue = clamp(Int(pixel.blue) + self.intensity * 128 / 100)
            break
        }
        
        return pixel
    }
}


// Instances for default Filter configurations
public let contrast2x = Contrast(intensity: 50)
public let contrast05x = Contrast(intensity: -50)
public let brightness2x = Brightness(intensity: 50)
//public let greenify = ColorBalance(intensity: 50, channel: .Green)
//public let redify = ColorBalance(intensity: 50, channel: .Red)
//public let bluify = ColorBalance(intensity: 50, channel: .Blue)