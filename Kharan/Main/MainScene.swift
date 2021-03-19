//
//  MainScene.swift
//  Kharan
//
//  Created by Edson Rottava Júnior on 17/07/19.
//  Copyright © 2019 Edson Rottava Júnior. All rights reserved.
//

import SpriteKit
import AVFoundation

class MainScene: SKScene, SKPhysicsContactDelegate {
    var viewController: MainController!
    private var bg = SKSpriteNode()
    private var bgFrames: [SKTexture] = []
    private var pd = SKSpriteNode()
    private var pdFrames: [SKTexture] = []
    private let statusBar = UIApplication.shared.statusBarFrame.height;
    private var player: SKSpriteNode = SKSpriteNode()
    private var points: Int = Int()
    private var update: TimeInterval = TimeInterval()
    private var timer: TimeInterval = TimeInterval()
    private var pos: CGPoint = CGPoint()
    private var newPos: CGPoint = CGPoint()
    private var alive: Bool = true
    private var audioPlayer = AVAudioPlayer()
    private var ringSound = SKAction.playSoundFileNamed("Ring", waitForCompletion: false)
    private var bombSound = SKAction.playSoundFileNamed("Bomb", waitForCompletion: false)
    private var bgSound = NSURL(fileURLWithPath:Bundle.main.path(forResource: "Background", ofType: "wav")!)
    
    let pointsLabel: SKLabelNode = {
        let label = SKLabelNode()
        label.text = "0"
        label.fontColor = UIColor.white
        label.fontName = "Marion-Regular"
        label.fontSize = 45
        label.horizontalAlignmentMode = .right
        return label
    }()
    
    override init(size:CGSize) {
        super.init(size: size)
        self.backgroundColor = SKColor.black
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        //self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
        setupPlayer()
        setupUI()
    }
    
    override func update(_ currentTime: CFTimeInterval) {
        var timeUpdate = currentTime - update
        update = currentTime
        
        if(timeUpdate > 1) {
            timeUpdate = 1/60
            update = currentTime
        }
        if (alive) {
            updateTime(timeUpdate: timeUpdate)
        }
    }
    
    override func didMove(to view: SKView) {
        buildBackground()
        animateBackground()
        playSound()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !(scene?.view?.isPaused ?? true) {
            let touch = touches.first
            if let location = touch?.location(in: self){
                player.run(SKAction.move(to: CGPoint(x:  pos.x + location.x - newPos.x, y: pos.y + location.y - newPos.y), duration: 0.1))
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let location = touch?.location(in: self)
        let touchedNode = self.atPoint(location!)
        selectAction(node: touchedNode)
        newPos = location!
        pos = player.position
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.bodyB.node?.name == "ring") {
            hitRing(ring: contact.bodyB.node as! SKSpriteNode)
        } else {
            hitBomb(bomb: contact.bodyB.node as! SKSpriteNode)
        }
        
    }
}

extension MainScene {
    //GameFunc
    private func hitRing(ring: SKSpriteNode) {
        run(ringSound)
        ring.removeFromParent()
        points += 1
        self.pointsLabel.text = String(points)
    }
    
    private func hitBomb(bomb: SKSpriteNode) {
        alive = false
        run(bombSound)
        gameOver()
        let nodeA = self.childNode(withName: "Back")!
        let nodeB = self.childNode(withName: "Box")!
        let over = SKSpriteNode(imageNamed: "Over")
        let fot:SKAction = SKAction.fadeOut(withDuration: 0.1)
        let fin:SKAction = SKAction.fadeIn(withDuration: 0.1)
        let seq:SKAction = SKAction.sequence([fot, fin])
        let fad:SKAction = SKAction.repeatForever(seq)
        let repeatFade:SKAction = SKAction.repeatForever(fad)
        over.run(repeatFade)
        self.addChild(over)
        switchNode(node: self.childNode(withName: "Play")!)
        switchNode(node: self.childNode(withName: "Reset")!)
        switchNode(node: nodeA)
        over.position = player.position
        nodeA.position.y = nodeB.position.y / 1.4
        self.childNode(withName: "Reset")!.position.y = nodeA.position.y
        pointsLabel.position.x = nodeB.position.x
        pointsLabel.position.y = nodeB.position.y
        pointsLabel.horizontalAlignmentMode = .center
        pointsLabel.fontName = "Marion-Bold"
        playerDead()
        animatePlayerDead()
        bomb.removeFromParent()
        player.removeFromParent()
        //switchNode(node: player)
    }
    
    private func updateTime(timeUpdate: CFTimeInterval) {
        timer += timeUpdate
        if (timer > 1) {
            timer = 0
            if (arc4random() % 2 == 0) {
                addBomb()
            } else {
                addRing()
            }
        }
    }
    
    private func addRing(){
        let ring: SKSpriteNode = SKSpriteNode(imageNamed: "Ring")
        ring.name = "ring"
        ring.color = setColor()
        ring.physicsBody = SKPhysicsBody(circleOfRadius: ring.size.width / 2, center: CGPoint(x: 0, y: 0))
        ring.physicsBody?.isDynamic = false
        ring.physicsBody?.categoryBitMask = CategoryMask.ring.rawValue
        ring.physicsBody?.collisionBitMask = ~(CategoryMask.player.rawValue | CategoryMask.bomb.rawValue)
        //ring.physicsBody?.contactTestBitMask = 0
        //Random position
        let minX = ring.size.width/2
        let maxX = self.frame.size.width - minX
        let rangeX = maxX - minX
        let position: CGFloat = CGFloat(arc4random()).truncatingRemainder(dividingBy: CGFloat(rangeX)) + CGFloat(minX)
        
        ring.position = CGPoint(x: position, y: self.frame.size.height+ring.size.height)
        ring.zPosition = 1
        self.addChild(ring)
        //Descend
        let minDuration = 3
        let maxDuration = 4
        let rangeDuration = maxDuration - minDuration
        let duration = Int(arc4random()) % Int(rangeDuration) + Int(minDuration)
        let actionArray: NSMutableArray = NSMutableArray()
        actionArray.add(SKAction.move(to: (CGPoint(x: position, y: -ring.size.height)), duration: TimeInterval(duration)))
        actionArray.add(SKAction.removeFromParent())
        ring.run(SKAction.sequence(actionArray as! [SKAction]))
        //Spin
        let oneRevolution:SKAction = SKAction.rotate(byAngle: CGFloat.pi * -2, duration: 1)
        let repeatRotation:SKAction = SKAction.repeatForever(oneRevolution)
        ring.run(repeatRotation)
    }
    
    private func addBomb(){
        let bomb: SKSpriteNode = SKSpriteNode(imageNamed: "Bomb")
        bomb.name = "bomb"
        bomb.color = setColor()
        bomb.physicsBody = SKPhysicsBody(circleOfRadius: bomb.size.width / 2, center: CGPoint(x: 0, y: 0))
        bomb.physicsBody?.isDynamic = false
        bomb.physicsBody?.categoryBitMask = CategoryMask.bomb.rawValue
        bomb.physicsBody?.collisionBitMask = ~(CategoryMask.player.rawValue | CategoryMask.ring.rawValue)
        //ring.physicsBody?.contactTestBitMask = 0
        //Random position
        let minX = bomb.size.width/2
        let maxX = self.frame.size.width - minX
        let rangeX = maxX - minX
        let position: CGFloat = CGFloat(arc4random()).truncatingRemainder(dividingBy: CGFloat(rangeX)) + CGFloat(minX)
        
        bomb.position = CGPoint(x: position, y: self.frame.size.height+bomb.size.height)
        bomb.zPosition = 1
        self.addChild(bomb)
        //Descend
        let minDuration = 3
        let maxDuration = 4
        let rangeDuration = maxDuration - minDuration
        let duration = Int(arc4random()) % Int(rangeDuration) + Int(minDuration)
        let actionArray: NSMutableArray = NSMutableArray()
        actionArray.add(SKAction.move(to: (CGPoint(x: position, y: -bomb.size.height)), duration: TimeInterval(duration)))
        actionArray.add(SKAction.removeFromParent())
        bomb.run(SKAction.sequence(actionArray as! [SKAction]))
        //Spin
        let big:SKAction = SKAction.resize(toWidth: bomb.size.width+2, height: bomb.size.height+2, duration: 0.7)
        let small:SKAction = SKAction.resize(toWidth: bomb.size.width-2, height: bomb.size.height-2, duration: 0.7)
        let seq:SKAction = SKAction.sequence([big, small])
        let bombS:SKAction = SKAction.repeatForever(seq)
        bomb.run(bombS)
    }
}

extension MainScene {
    //UIFunc
    private func setupPlayer() {
        let hit = CategoryMask.ring.rawValue | CategoryMask.bomb.rawValue
        player = SKSpriteNode(imageNamed: "Player")
        player.color = UIColor.white
        player.position = CGPoint(x: self.frame.size.width/2, y: player.size.height/2+20)
        player.physicsBody = SKPhysicsBody(circleOfRadius: (player.size.width-1) / 2, center: CGPoint(x: 0, y: 0))
        player.physicsBody?.categoryBitMask = CategoryMask.player.rawValue
        player.physicsBody?.collisionBitMask = hit
        player.physicsBody?.contactTestBitMask = hit
        player.physicsBody?.isDynamic = true
        player.name = "player"
        let xRange = SKRange(lowerLimit:player.size.width/2,upperLimit:size.width-(player.size.width/2))
        let yRange = SKRange(lowerLimit:player.size.height/2,upperLimit:size.height-player.size.height)
        player.constraints = [SKConstraint.positionX(xRange,y:yRange)]
        player.zPosition = 8
        self.addChild(player)
    }
    
    private func setupUI() {
        pointsLabel.position = CGPoint(x:self.frame.maxX - 10, y:self.frame.maxY - 60)
        pointsLabel.zPosition = 9
        self.addChild(pointsLabel)
        setNode(name: "Play")
        setNode(name: "Pause")
        setMenu(name: "Back")
        setMenu(name: "Reset")
        switchNode(node: self.childNode(withName: "Pause")!)
        self.childNode(withName: "Pause")!.position.x += 3
        switchNode(node: self.childNode(withName: "Back")!)
        self.childNode(withName: "Back")!.position.x += self.childNode(withName: "Back")!.frame.size.width/2 + 5
        switchNode(node: self.childNode(withName: "Reset")!)
        self.childNode(withName: "Reset")!.position.x -= self.childNode(withName: "Reset")!.frame.size.width/2 - 5
        points = 0
    }
    
    private func setNode(name: String) {
        let node = SKSpriteNode(imageNamed: name)
        node.position = CGPoint(x:self.frame.minX + 30 , y:self.frame.maxY - 40)
        node.name = name
        node.size.height = 40
        node.size.width = 40
        node.zPosition = 9
        self.addChild(node)
    }
    
    private func setMenu(name: String) {
        let node = SKSpriteNode(imageNamed: name)
        node.position = CGPoint(x:self.frame.midX , y:self.frame.midY)
        node.name = name
        node.size.height = 60
        node.size.width = 60
        node.zPosition = 9
        self.addChild(node)
    }
    
    private func switchNode(node: SKNode) {
        if (node.isHidden) {
            node.isHidden = false
            node.isPaused = false
        } else {
            node.isHidden = true
            node.isPaused = true
        }
    }
    
    @objc private func swithRun() {
        self.isPaused = !(self.isPaused)
    }
    
    private func selectAction(node: SKNode){
        if let name = node.name {
            switch (name) {
            case "Play" :
                switchNode(node: node)
                switchNode(node: self.childNode(withName: "Pause")!)
                switchNode(node: self.childNode(withName: "Back")!)
                switchNode(node: self.childNode(withName: "Reset")!)
                perform(#selector(swithRun), with: nil, afterDelay: 0.05)
                break
            case "Pause":
                switchNode(node: node)
                switchNode(node: self.childNode(withName: "Back")!)
                switchNode(node: self.childNode(withName: "Reset")!)
                switchNode(node: self.childNode(withName: "Play")!)
                swithRun()
                break
            case "Back":
                self.removeAllChildren()
                self.removeAllActions()
                self.removeFromParent()
                self.view?.presentScene(nil)
                self.viewController.prepareView()
                swithRun()
                break
            case "Reset":
                self.removeAllChildren()
                self.removeAllActions()
                self.removeFromParent()
                self.view?.presentScene(nil)
                self.viewController.setupGameView()
                //swithRun()
                break
            default :
                break
            }
        }
    }
    
    private func buildBackground() {
        let background = SKTextureAtlas(named: "Background")
        var bgFrame: [SKTexture] = []
        
        let numImages = background.textureNames.count
        for i in (1...numImages).reversed() {
            let bgTextureName = "Background-\(i)"
            bgFrame.append(background.textureNamed(bgTextureName))
        }
        bgFrames = bgFrame
        
        let firstFrameTexture = bgFrames[0]
        bg = SKSpriteNode(texture: firstFrameTexture)
        bg.position = CGPoint(x:self.frame.midX , y:self.frame.midY)
        bg.size = CGSize(width: self.size.width, height: self.size.height)
        addChild(bg)
    }
    
    func animateBackground() {
        bg.run(SKAction.repeatForever(
            SKAction.animate(with: bgFrames,
                             timePerFrame: 0.1,
                             resize: false,
                             restore: true)),
               withKey:"skyBG")
    }
    
    private func playerDead() {
        let explosion = SKTextureAtlas(named: "Explosion")
        var pdFrame: [SKTexture] = []
        
        let numImages = explosion.textureNames.count
        for i in (1...numImages) {
            let pdTextureName = "Explosion-\(i)"
            pdFrame.append(explosion.textureNamed(pdTextureName))
        }
        pdFrames = pdFrame
        
        let firstFrameTexture = pdFrames[0]
        pd = SKSpriteNode(texture: firstFrameTexture)
        pd.position = CGPoint(x: player.frame.midX , y: player.frame.midY)
        pd.size = CGSize(width: pd.size.width, height: pd.size.height)
        addChild(pd)
    }
    
    func animatePlayerDead() {
        pd.run(SKAction.repeat((
            SKAction.animate(with: pdFrames,
                             timePerFrame: 0.1,
                             resize: false,
                             restore: true)),
                               count: 1))
    }
    
    private func gameOver() {
        
        let w = self.size.width * 0.75
        let h = self.size.height * 0.50
        let form: SKShapeNode = {
            let shape = SKShapeNode()
            shape.path = UIBezierPath(roundedRect: CGRect(x: -w/2, y: -h/2, width: w, height: h), cornerRadius: 16).cgPath
            shape.position = CGPoint(x: self.frame.midX , y: self.frame.midY)
            shape.fillColor = UIColor.blue
            shape.strokeColor = UIColor.clear
            shape.alpha = 0.15
            shape.zPosition = 5
            shape.name = "Box"
            return shape
        }()
        self.addChild(form)
        let go: SKLabelNode = {
            let label = SKLabelNode()
            label.text = "Your score:"
            label.fontColor = UIColor.white
            label.fontName = "Marion-Bold"
            label.fontSize = 32
            label.horizontalAlignmentMode = .center
            label.zPosition = 6
            label.name = "EndLabel"
            return label
        }()
        self.addChild(go)
        go.position.x = form.position.x
        go.position.y = form.position.y * 1.3
    }
    
    private func playSound() {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: bgSound as URL)
            audioPlayer.prepareToPlay()
        } catch {
            print("Problem in getting File")
        }
        audioPlayer.play()
    }
    
    private func setColor() -> UIColor {
        let color = Int.random(in: 0...7)
        switch color {
        case 0:
            return UIColor.red
        case 1:
            return UIColor.yellow
        case 2:
            return UIColor.blue
        case 3:
            return UIColor.orange
        case 4:
            return UIColor.purple
        case 5:
            return UIColor.green
        case 6:
            return UIColor.white
        default:
            return UIColor.black
        }
    }
    
}

extension MainScene {
    //Enum
    enum CategoryMask: UInt32 {
        case player = 0b01
        case ring = 0b10
        case bomb = 0b11
    }
    
    enum ColorMask: UInt32 {
        case red = 0b001
        case yellow = 0b010
        case blue = 0b100
        case green = 0b110
        case orange = 0b011
        case purple = 0b101
        case white = 0b111
    }
}
