classdef AABBox
    
    properties
        mMin = [0,0,0];     % Bottom left (min)
        mMax = [0,0,0];     % Top right   (max)
        
    end
    
    methods
        
        
        function [obj] = AABBox(min_, max_)
            obj.mMin = min_;
            obj.mMax = max_;
            
        end
        
        % Expand to fit box
        function [obj] = expand(obj,box)
            if (box.mMin(1) < obj.mMin(1))
                obj.mMin(1) = box.mMin(1);
            end
            if (box.mMin(2)< obj.mMin(2))
                obj.mMin(2) = box.mMin(2);
            end
            if (box.mMin(3) < obj.mMin(3))
                obj.mMin(3) = box.mMin(3);
            end
            
            if (box.mMax(1) > obj.mMax(1))
                obj.mMax(1) = box.mMax(1);
            end
            if (box.mMax(2) > obj.mMax(2))
                obj.mMax(2) = box.mMax(2);
            end
            if (box.mMax(3) > obj.mMax(3))
                obj.mMax(3) = box.mMax(3);
            end
        end
        
        function obj = set.mMin(obj,mMin_)
            obj.mMin = mMin_;
        end
        
        function obj = set.mMax(obj,mMax_)
            obj.mMax = mMax_;
        end
        
        function [output] = getLongestAxis(obj)
            diff = obj.mMax - obj.mMin;
            
            
            if ( diff(1) > diff(2) && diff(1) > diff(3) )
                output = 0;
                return
            end
            if (diff(2) > diff(1) && diff(2)> diff(3))
                output = 1;
                return
            end
            
            output = 2;
            return
        end
        
        function [OutBIsIntersect] = intersection(obj, InRay)
            

            
            origin          = InRay.origin;
            fractionDir     = 1./ InRay.direction;
            
            OutBIsIntersect = false;
            
            objMin = obj.mMin;
            objMax = obj.mMax;

            % -- t0x = (B0x - Ox) / Dx (eq2) -- 
            t0x = ( objMin(1) - origin(1) ) * fractionDir(1);  % X min
            t1x = ( objMax(1) - origin(1) ) * fractionDir(1);  % X max

            t0y = ( objMin(2) - origin(2) ) * fractionDir(2);  % Y min
            t1y = ( objMax(2) - origin(2) ) * fractionDir(2);  % Y Max
            
            t0z = ( objMin(3) - origin(3) ) * fractionDir(3);  % Z min
            t1z = ( objMax(3) - origin(3) ) * fractionDir(3);  % Z max
            
            
            tmin = max( max( min(t0x, t1x), min(t0y, t1y)) , min(t0z, t1z) );
            tmax = min( min(  max(t0x, t1x), max(t0y, t1y) ), max(t0z, t1z));
            
            
            % if tmax < 0, ray (line) is intersecting AABB, but whole AABB is behing us
            if (tmax < 0)
                return
            end
            % if tmin > tmax, ray doesn't Hit AABB
            if (tmin > tmax)
                return
            end
            
            OutBIsIntersect = true;
            return
            
        end
        
    end
    
end