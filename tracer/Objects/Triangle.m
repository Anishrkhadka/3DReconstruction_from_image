%% Triangle class takes in 3 vertex and 3 normals.
% Intersection function: The function define the interaction between the
% ray and the triangle.
% getBoundingBox function: The function returns a AABBox with triangle
% within.
% getMidPoint function:  The function returns the 3D mid point of the
% triangle vertex.


classdef Triangle
    
    properties
        vertex0 = [0,0,0];
        vertex1 = [0,0,0];
        vertex2 = [0,0,0];
        edge1   = [0,0,0];
        edge2   = [0,0,0];
        
        faceNormal = [0,0,0];
        
    end
    
    methods
        
        function [obj] = Triangle( InVertex0, InVertex1, InVertex2, InNormal)
            
            obj.vertex0 = InVertex0;
            obj.vertex1 = InVertex1;
            obj.vertex2 = InVertex2;
            
            obj.edge1   = InVertex1 - InVertex0;
            obj.edge2   = InVertex2 - InVertex0;
            
            obj.faceNormal = InNormal;
            
        end
        
        
        
        
        function[OutObjectData] = intersection(obj,InRay)
            % Triangle Intersect function takes in Ray and return t value
            % t value is higher than 0 if ray hits triangle
            
            rayDirection = InRay.direction;
            objEdge1     = obj.edge1;
            objEdge2     = obj.edge2;
            
            %             det    = 0;
            %             inv_det= 0;
            %             u      = 0;
            %             v      = 0;
            %
            %
            %             P 	   = [0,0,0];
            %             Q 	   = [0,0,0];
            %             T 	   = [0,0,0];
            
            
            OutObjectData{1}    = 0;  % Closest T
            OutObjectData{2}    = [0,0,0];  % Normal
            
%             OutObjectData = zeros(1,3,2);
            
            inf       = 1e7;
            
            EPSILON  = 1e-06;
            
            P   = crossP( rayDirection, objEdge2 );
            
            det = dotp( objEdge1, P );
            
            if( det > -EPSILON && det < EPSILON )
                
                return
            end
            
            inv_det = 1 / det;
            T       = InRay.origin - obj.vertex0;
            u       = dotp( T, P ) * inv_det;
            
            if (u < 0 || u >1)
                return
            end
            
            Q       = crossP( T, objEdge1 );
            
            v       = dotp(rayDirection, Q) * inv_det;
            
            if(v < 0 || u + v  > 1)
                return
            end
            
            t       = dotp( objEdge2, Q ) * inv_det;
            
            if( t > EPSILON && t < inf )
                
                OutObjectData{1} = t;
                OutObjectData{2} = obj.faceNormal;
                
      
                
                return
            end
            
            OutObjectData{1}    = 0;  % Closest T
            OutObjectData{2}    = [0,0,0];  % Normal
       
            return
            
        end
        
        function [OutAAbbox] = getBoundingBox(obj)
            
            x1 = min ( min(obj.vertex0(1), obj.vertex1(1) ), obj.vertex2(1) );
            y1 = min ( min(obj.vertex0(2), obj.vertex1(2) ), obj.vertex2(2) ) ;
            z1 = min ( min(obj.vertex0(3), obj.vertex1(3) ), obj.vertex2(3) );
            
            bl = [x1,y1,z1];
            
            x2 = max (max(obj.vertex0(1), obj.vertex1(1)), obj.vertex2(1) );
            y2 = max (max(obj.vertex0(2), obj.vertex1(2)), obj.vertex2(2) );
            z2 = max (max(obj.vertex0(3), obj.vertex1(3)), obj.vertex2(3) );
            
            tr = [x2,y2,z2];
            OutAAbbox = AABBox(bl,tr);
            
            return
        end
        
        function [midPoint] = getMidPoint (obj)
            midPoint = ( obj.vertex0 + obj.vertex1+ obj.vertex2 ) / 3.0;
            return
        end
        
    end
    
    
end