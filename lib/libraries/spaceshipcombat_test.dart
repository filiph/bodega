//import 'package:test/test.dart';
import 'package:egamebook/scripter.dart';
import 'package:egamebook/src/shared/form.dart';

import 'spaceship.dart';
import 'spaceshipcombat.dart';
import 'storyline.dart';

void main() {
  isInInitOrDeclareBlock = true;
  var player = new Pilot.player();

  // setup ships
  var ship1 = new Spaceship("Bodega",
      pilot: player,
      hull: new Hull(maxHp: 100),
      shield: new Shield(maxHp: 20, maxPowerInput: 2.0),
      engine: new Engine(maxHp: 10, maxPowerOutput: 10.0),
      thrusters: [
    new Thruster("Main Jet",
        maxHp: 5, maxPowerInput: 5.0, maxForwardlyForce: 100),
    new Thruster("Left Side Thrusters",
        maxHp: 1, maxPowerInput: 1.0, maxManeuverability: 5),
    new Thruster("Right Side Thrusters",
        maxHp: 1, maxPowerInput: 1.0, maxManeuverability: 5)
  ],
      weapons: [new Weapon("Front Utility Laser")]);
//  ship1.hull.hp.onPassDownwards(50).take(1).listen((_) =>
//      ship1.report("<subject's> hull has taken some major damage"));

  var ship2 = new Spaceship("Messenger",
      hull: new Hull(maxHp: 15),
      shield: new Shield(maxHp: 10, maxPowerInput: 1.0),
      engine: new Engine(maxHp: 10, maxPowerOutput: 2.0),
      thrusters: [
    new Thruster("Main Jet",
        maxHp: 3, maxPowerInput: 1.0, maxForwardlyForce: 10),
    new Thruster("Rotation Thrusters",
        maxHp: 1, maxPowerInput: 0.5, maxManeuverability: 10),
  ],
      weapons: [new Weapon("Left Blaster"), new Weapon("Right Blaster")]);

  ship1.targetShip = ship2;
  ship2.targetShip = ship1;

  // setup combat
  var combat = new SpaceshipCombat(ships: [ship1, ship2]);
  combat.timeline.schedule(5, "String event.");
  combat.timeline.schedule(6, () => ship1.engine.hp.value--);
  combat.timeline.schedule(7, () =>
      ship2.report("<subject> is starting to circle <object>", object: ship1));

  combat.onFinishedGoto = "something";

  player.timeToNextInteraction = 1;
  isInInitOrDeclareBlock = false;

  // ---
  // combatloop
  combat.run();

  print(currentForm.toMap());

  // - [combatloop]

  // ---
  // something

  /*
Engine Example

First choice
- Reroute energy (10.0 MJ output, 12.0 MJ needed)

| System | Power Demand | Power Input | Effectiveness |
| Laser  | 2.0 MJ       | 1.5 MJ      | 75 %          | 

The engine generates 10.0 MJ. 
- Prioritize Laser Gun (strive for power input of 2.0 MJ, 100 % effectiveness)
- Turn off Laser Gun (free 1.5 MJ for other systems)
   */

  /*
Laser Gun Example

First choice
- Start firing at Messenger with Utility Laser Gun

What exactly do you target on the Messenger?
- Target the hull (60 % chance of hit)
- Target the main jet (20 % chance of hit)
- Target the maneuverability thrusters (15 % chance of hit)
- Target the cockpit (10 % chance of hit)
- Target the left blaster (10 % chance of hit)

You start to set up the utility laser. The Messenger initiates a barrel roll. 
The Utility Laser Gun is now targeted at the Messenger's hull and charging.
...
The ULG's laser beam connects with the Messenger's shields. Its force is too
strong for them. They are instantly depleted. The laser beam still has energy
left and it deals minor damage to the Messenger's hull. The ULG starts
recharging for another round.
...

- Change Utility Laser Gun setup

The Laser Gun is currently targetting the Messenger's hull.
- Stop firing
- Target ....
- Target ...
- Leave it be
 
   */
}
