//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Cocoa
import LIFXOSX

class ViewController: NSViewController, LFXNetworkContextObserver, LFXLightCollectionObserver, LFXLightObserver
{
    let lifxNetworkContext: LFXNetworkContext
    var lights: LFXLight[]?
    var taggedLightCollections: LFXLightCollection[]?
    
    init(coder: NSCoder!)
    {
        self.lifxNetworkContext = LFXClient.sharedClient().localNetworkContext
        super.init(coder: coder)
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        self.lifxNetworkContext.addNetworkContextObserver(self)
        self.lifxNetworkContext.allLightsCollection.addLightCollectionObserver(self)
    }
    
    override func viewWillAppear()
    {
        super.viewWillAppear()
        
        self.updateTitle()
        self.updateLights()
        self.updateTags()
    }
    
    func updateLights()
    {
        self.lights = self.lifxNetworkContext.allLightsCollection.lights as? LFXLight[]
        // FIXME: reload tv data
        
        if self.lights?.count > 0
        {
            let light: LFXLight = self.lights![0]
            
            let color: LFXHSBKColor = LFXHSBKColor(hue: 0.7, saturation: 0.5, brightness: 0.1)
            light.setColor(color)
        }
    }
    
    func updateTags()
    {
        self.taggedLightCollections = self.lifxNetworkContext.taggedLightCollections as? LFXLightCollection[]
        // FIXME: reload tv data
    }
    
    func updateTitle()
    {
        let status = self.lifxNetworkContext.isConnected ? "connected" : "searching"
        self.title = "LIFX Browser \(status)"
    }
    
    //LFXNetworkContextObserver
    
    func networkContextDidConnect(networkContext: LFXNetworkContext!)
    {
        println("Network Context Did Connect")
        self.updateTitle()
    }
    
    func networkContextDidDisconnect(networkContext: LFXNetworkContext!)
    {
        println("Network Context Did Disconnect")
        self.updateTitle()
    }
    
    func networkContext(networkContext: LFXNetworkContext!, didAddTaggedLightCollection collection: LFXTaggedLightCollection!)
    {
        println("Network Context Did Add Tagged Light Collection: \(collection.tag)")
        collection.addLightCollectionObserver(self)
        self.updateTags()
    }
    
    func networkContext(networkContext: LFXNetworkContext!, didRemoveTaggedLightCollection collection: LFXTaggedLightCollection!)
    {
        println("Network Context Did Add Removed Light Collection: \(collection.tag)")
        collection.removeLightCollectionObserver(self)
        self.updateTags()
    }
    
    // LFXLightCollectionObserver
    
    func lightCollection(lightCollection: LFXLightCollection!, didAddLight light: LFXLight!)
    {
        println("Light Collection: \(lightCollection) Did Add Light: \(light)")
        light.addLightObserver(self)
        self.updateLights()
    }
    
    func lightCollection(lightCollection: LFXLightCollection!, didRemoveLight light: LFXLight!)
    {
        println("Light Collection: \(lightCollection) Did Remove Light: \(light)")
        light.removeLightObserver(self)
        self.updateLights()
    }
    
    // LFXLightObserver
    func light(light: LFXLight!, didChangeLabel label: String!)
    {
        println("Light: \(light) Did Change Label: \(label)");
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
                                    
    }


}

