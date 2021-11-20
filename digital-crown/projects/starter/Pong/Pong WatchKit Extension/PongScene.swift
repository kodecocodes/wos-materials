import SpriteKit
import SwiftUI

// swiftlint:disable implicitly_unwrapped_optional

final class PongScene: SKScene {
  @Binding var crownPosition: Double

  private let maxPaddleY: Double
  private let minPaddleY: Double
  private let paddleHeight: Double
  private let initialPaddleY: Double

  // swiftlint:disable:next force_unwrapping
  private let green = UIColor(named: "RWGreen")!

  private var leftScoreLabel: SKLabelNode!
  private var rightScoreLabel: SKLabelNode!
  private var leftPaddle: SKSpriteNode!
  private var rightPaddle: SKSpriteNode!
  private var ball: SKShapeNode!
  private var previousCrownPosition: Double
  private var paddleBeingMoved: SKSpriteNode!
  private var ballAtFullSpeed = false

  private var leftScore = 0 {
    didSet {
      leftScoreLabel.text = "\(leftScore)"
    }
  }

  private var rightScore = 0 {
    didSet {
      rightScoreLabel.text = "\(rightScore)"
    }
  }

  init(size: CGSize, crownPosition: Binding<Double>) {
    _crownPosition = crownPosition
    previousCrownPosition = 1
    paddleHeight = size.height / 3.0
    minPaddleY = paddleHeight / 2.0
    maxPaddleY = size.height - minPaddleY
    initialPaddleY = size.height / 2.0

    super.init(size: size)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("This should never be called.")
  }

  override func update(_ currentTime: TimeInterval) {
    super.update(currentTime)

    if ball.position.x <= leftPaddle.position.x {
      scored(winner: .right)
    } else if ball.position.x >= rightPaddle.position.x {
      scored(winner: .left)
    }
  }
}

extension PongScene {
  override func sceneDidLoad() {
    super.sceneDidLoad()

    ball = createBall()
    addChild(ball)

    leftPaddle = createPaddle(isLeft: true)
    leftPaddle.color = .red
    addChild(leftPaddle)

    rightPaddle = createPaddle(isLeft: false)
    addChild(rightPaddle)

    leftScoreLabel = createLabel(isLeft: true)
    rightScoreLabel = createLabel(isLeft: false)

    createDividerLine()

    let border = SKPhysicsBody(edgeLoopFrom: frame)
    border.friction = 0
    border.restitution = 1

    physicsBody = border
    physicsWorld.contactDelegate = self

    paddleBeingMoved = rightPaddle
    resetBall(moving: .right)
  }

  private func createDividerLine() {
    let x = size.width / 2.0

    let path = CGMutablePath()
    path.addLines(between: [.init(x: x, y: 0), .init(x: x, y: size.height)])

    let line = SKShapeNode()
    line.path = path.copy(dashingWithPhase: 1, lengths: [5, 5])
    line.strokeColor = .gray
    line.lineWidth = 2

    addChild(line)
  }

  private func createPaddle(isLeft: Bool) -> SKSpriteNode {
    let x: Double = isLeft ? 10 : size.width - 20
    let paddleSize = CGSize(width: 10, height: paddleHeight)

    let body = SKPhysicsBody(rectangleOf: paddleSize)
    body.category(isLeft ? .leftPaddle : .rightPaddle, collidesWith: .ball, isDynamic: false)

    let node = SKSpriteNode(color: green, size: paddleSize)
    node.position = .init(x: x, y: initialPaddleY)
    node.physicsBody = body

    return node
  }

  private func createBall() -> SKShapeNode {
    let node = SKShapeNode(circleOfRadius: 5)
    node.position = .init(x: frame.midX, y: frame.midY)
    node.fillColor = green

    let body = SKPhysicsBody(circleOfRadius: 5)
    body.category(.ball, collidesWith: [.leftPaddle, .rightPaddle])
    body.linearDamping = 0
    body.angularDamping = 0
    body.restitution = 1.0

    node.physicsBody = body

    return node
  }

  private func createLabel(isLeft: Bool) -> SKLabelNode {
    let offset = isLeft ? -60.0 : 60.0

    let node = SKLabelNode(text: "0")
    node.position = .init(x: frame.midX + offset, y: frame.maxY - 30)
    node.fontSize = 30
    addChild(node)

    return node
  }

  private func resetBall(moving: Direction) {
    let offset = moving == .left ? -0.15 : 0.15
    ball.position = .init(x: frame.midX, y: frame.midY)
    ball.physicsBody?.velocity = .zero
    ball.physicsBody?.applyImpulse(.init(dx: offset, dy: offset))
    ballAtFullSpeed = false

    paddleBeingMoved = (moving == .left) ? leftPaddle : rightPaddle
  }

  private func scored(winner: Direction) {
    if winner == .left {
      leftScore += 1
      resetBall(moving: .right)
    } else {
      rightScore += 1
      resetBall(moving: .left)
    }
  }
}

extension PongScene: SKPhysicsContactDelegate {
  func didEnd(_ contact: SKPhysicsContact) {
    if contact.bodyA.node == leftPaddle || contact.bodyB.node == leftPaddle {
      paddleBeingMoved = rightPaddle
      leftPaddle.color = .red
    } else if contact.bodyA.node == rightPaddle || contact.bodyB.node == rightPaddle {
      paddleBeingMoved = leftPaddle
      rightPaddle.color = .red
    }

    paddleBeingMoved.color = green

    guard ballAtFullSpeed == false else { return }

    let offset = paddleBeingMoved == leftPaddle ? 0.5 : -0.5
    ball.physicsBody?.velocity = .zero
    ball.physicsBody?.applyImpulse(.init(dx: offset, dy: offset))
    ballAtFullSpeed = true
  }
}

extension SKPhysicsBody {
  func category(_ category: ShapeType, collidesWith: ShapeType, isDynamic: Bool = true) {
    categoryBitMask = category.rawValue
    collisionBitMask = collidesWith.rawValue
    contactTestBitMask = collidesWith.rawValue
    fieldBitMask = 0
    allowsRotation = false
    affectedByGravity = false
    friction = 0
    restitution = 0
    self.isDynamic = isDynamic
  }
}

struct ShapeType: OptionSet {
  let rawValue: UInt32
  static let ball = ShapeType(rawValue: 1 << 0)
  static let leftPaddle = ShapeType(rawValue: 1 << 1)
  static let rightPaddle = ShapeType(rawValue: 1 << 2)
}

enum Direction {
  case left, right
}
