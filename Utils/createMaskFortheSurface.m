function createMaskFortheSurface (InMaskName, InMeshInSurfaceMode)
    fileName = strcat(InMaskName, '.ppm');
    imwrite( InMeshInSurfaceMode, fileName);
end
