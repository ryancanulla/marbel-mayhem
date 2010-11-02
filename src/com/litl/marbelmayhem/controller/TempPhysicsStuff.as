// ActionScript file

//                var angle:Number = Math.atan2(distZ, distX);
//                var sin:Number = Math.sin(angle);
//                var cos:Number = Math.cos(angle);
//
//                // rotate player positions
//                var x0:Number = 0;
//                var y0:Number = 0;
//                var x1:Number = distX * cos + distZ * sin;
//                var y1:Number = distZ * cos - distX * sin;
//
//                // rotate velocities
//                var vx0:Number = player1VX * cos + player1VY * sin;
//                var vy0:Number = player1VY * cos - player1VX * sin;
//                var vx1:Number = player2VX * cos + player2VY * sin;
//                var vy1:Number = player2VY * cos - player2VX * sin;
//
//                // collision reaction
//                var vxTotal:Number = vx0 - vx1;
//                vx0 = ((MASS - MASS) * vx0 + 2 * MASS * vx1) / (MASS + MASS);
//                vx1 = vxTotal + vx0;
//
//                //seperate them
//                //x0 += vx0;
//                //x1 += vx1;
//
//                // seperate them advanced
//                var absV:Number = Math.abs(vx0) + Math.abs(vx1);
//                var overlap:Number = (player0.radius + player1.radius)
//                    - Math.abs(x0 - x1);
//
//                x0 += vx0 / absV * overlap;
//                x1 += vx1 / absV * overlap;
//
//                // rotate positions back
//                var x0Final:Number = x0 * cos - y0 * sin;
//                var y0Final:Number = y0 * cos + x0 * sin;
//                var x1Final:Number = x1 * cos - y1 * sin;
//                var y1Final:Number = y1 * cos + x1 * sin;
//
//                // adjust positions to actual screen positions
//                player1.x = player0.x + x1Final;
//                player1.z = player0.z + y1Final;
//                player0.x = player0.x + x0Final;
//                player0.z = player0.z + y0Final;
//
//                // rotate the velocities back
//                player1VX = vx0 * cos - vy0 * sin;
//                player1VY = vy0 * cos + vx0 * sin;
//                player2VX = vx1 * cos - vy1 * sin;
//                player2VY = vy1 * cos + vx1 * sin;

//                var angle:Number = Math.atan2(distZ, distX);
//                var sin:Number = Math.sin(angle);
//                var cos:Number = Math.cos(angle);
//
//                // rotate player positions
//                var pos0:Point = new Point(0, 0);
//                var pos1:Point = rotate(distX, distZ, sin, cos, true);
//
//                var x1:Number = distX * cos + distZ * sin;
//                var y1:Number = distZ * cos - distX * sin;
//
//                // rotate velocities
//                var vx0:Number = player1VX * cos + player1VY * sin;
//                var vy0:Number = player1VY * cos - player1VX * sin;
//                var vx1:Number = player2VX * cos + player2VY * sin;
//                var vy1:Number = player2VY * cos - player2VX * sin;
//
//                // collision reaction
//                var vxTotal:Number = vx0 - vx1;
//                vx0 = ((MASS - MASS) * vx0 + 2 * MASS * vx1) / (MASS + MASS);
//                vx1 = vxTotal + vx0;
//
//                //seperate them
//                //x0 += vx0;
//                //x1 += vx1;
//
//                // seperate them advanced
//                var absV:Number = Math.abs(vx0) + Math.abs(vx1);
//                var overlap:Number = (player0.radius + player1.radius)
//                    - Math.abs(x0 - x1);
//
//                x0 += vx0 / absV * overlap;
//                x1 += vx1 / absV * overlap;
//
//                // rotate positions back
//                var x0Final:Number = x0 * cos - y0 * sin;
//                var y0Final:Number = y0 * cos + x0 * sin;
//                var x1Final:Number = x1 * cos - y1 * sin;
//                var y1Final:Number = y1 * cos + x1 * sin;
//
//                // adjust positions to actual screen positions
//                player1.x = player0.x + x1Final;
//                player1.z = player0.z + y1Final;
//                player0.x = player0.x + x0Final;
//                player0.z = player0.z + y0Final;
//
//                // rotate the velocities back
//                player1VX = vx0 * cos - vy0 * sin;
//                player1VY = vy0 * cos + vx0 * sin;
//                player2VX = vx1 * cos - vy1 * sin;
//                player2VY = vy1 * cos + vx1 * sin;
