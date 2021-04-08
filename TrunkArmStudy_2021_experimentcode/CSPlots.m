% This you should get from the file you saved

HT=  1.0e+02 * [-0.000654743414347   0.009820289841634   0.001770089965981   1.198563385009766;...
  -0.009978481261399  -0.000638139345697  -0.000150631641397  -0.484770622253418;...
  -0.000034968232513  -0.001776143463173   0.009840939570028  -0.267241516113281;...
                   0                   0                   0   0.010000000000000];

quiver(HT([1 1],4)',HT([2 2],4)',HT(1,1:2),HT(2,1:2))
text(HT(1,4)+HT(1,1:2),HT(2,4)+HT(2,1:2),{'x','y'})

quiver3(HT([1 1 1],4)',HT([2 2 2],4)',HT([3 3 3],4)',HT(1,1:3),HT(2,1:3),HT(3,1:3))
text(HT(1,4)+HT(1,1:3),HT(2,4)+HT(2,1:3),HT(3,4)+HT(3,1:3),{'x','y','z'})

