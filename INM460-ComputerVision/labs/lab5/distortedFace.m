function newFace = distortedFace(face) % more parameters TODO
    r = @(x) sqrt(x(:,1).^2 + x(:,2).^2);
    w = @(x) atan2(x(:,2), x(:,1));
    f = @(x) [sqrt(r(x)) .* cos(w(x)), sqrt(r(x)) .* sin(w(x))];
    g = @(x, unused) f(x);

    tform2 = maketform('custom', 2, 2, [], g, []);
    face2 = imtransform(face, tform2, 'UData', [-1 1], 'VData', [-1 1], ...
        'XData', [-1 1], 'YData', [-1 1]);
    newFace = face2;
end    