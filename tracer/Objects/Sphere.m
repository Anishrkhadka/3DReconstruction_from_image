classdef Sphere
    
    properties
        radius     = 0;
        position   = [0,0,0];
        emission   = [0,0,0];
        colour      = [0,0,0];
        materialType = 0
        
    end
    
    methods
        
        function [obj] = Sphere(InRadius, InPosition, InEmission, InColour, InMaterialType)
            obj.radius       = InRadius;
            obj.position     = InPosition;
            obj.emission     = InEmission;
            obj.colour       = InColour;
            obj.materialType = InMaterialType;
            
        end
        
        
        function[OutObjectData] = intersection(obj,InRay)
            
            ObjPosition  = obj.position;
            
            rayDirection = InRay.direction;
            rayOrigin    = InRay.origin;

            
            OutObjectData{1}  = 0;
            OutObjectData{2}  = [0,0,0];
                
            op      = ObjPosition - rayOrigin;
%             t       = 0;
            eps     = 1e-4;
            b       = dotp( op, rayDirection );
           
            
            det     = b ^ 2 - dotp( op, op ) + obj.radius^2;
            
            if (det < 0)
                return
            else
                det = sqrt( det );
            end
            
            t1 =  b - det;
            t2 =  b + det;
            
            if ( t1 > eps)
                OutObjectData{1} = t1;
                % -- Calculate the normal --
                OutObjectData{2} = unit( ( rayOrigin +  rayDirection * t1 ) - ObjPosition );
                
                return
                
            elseif ( t2 > eps)
                OutObjectData{1} = t2;
                OutObjectData{2} = unit( ( rayOrigin +  rayDirection * t2 ) - ObjPosition );
                return
            else
              
                return
            end
        end
        
        function [OutPoint] = getPointOnSurface(obj)
            u = rand;
            v = rand;
            theta = 2 * pi * u;
            phi   = acos(2 * v - 1);
            x = obj.position(1) + ( obj.radius * sin(phi) * cos(theta) );
            y = obj.position(2) + ( obj.radius * sin(phi) * sin(theta) );
            z = obj.position(3) + ( obj.radius * cos(phi));
            
            OutPoint = [x,y,z];
        end
        
        
        
    end
    
    
end