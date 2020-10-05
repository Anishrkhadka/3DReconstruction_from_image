classdef KDNode <handle
    
    properties
        aabox            = AABBox([0,0,0],[0,0,0]);
        leftNode         = [];
        rightNode        = [];
        trianglesList    = [];
        leaf            = false;
    end
    
    
    methods
        
%                 function [obj] = set.leaf(obj,value)
%                     obj.leaf = value;
%                 end
%                 function [obj] = set.leftNode(obj,value)
%                     obj.leftNode = value;
%                 end
%                 function [obj] = set.rightNode(obj,value)
%                     obj.rightNode = value;
%                 end
%                 function [obj] = set.trianglesList(obj,value)
%                     obj.trianglesList = value;
%                 end
%                 function [obj] = set.aabox(obj,value)
%                     obj.aabox = value;
%                 end
        
        
        function [ OutObjectData ] = intersection(obj,InRay)
            
            OutObjectData{1} = 1e20;
            OutObjectData{2} = [0,0,0];
            
            
            if ( obj.aabox.intersection(InRay) )
                
                if ( obj.leaf ~= true )
                    
                    [InObjectData] = obj.leftNode.intersection(InRay);
                    
                    if (InObjectData{1} && InObjectData{1} < OutObjectData{1})
                        OutObjectData = InObjectData;
                    end
                    
                    [InObjectData] = obj.rightNode.intersection(InRay);
                    
                    if (InObjectData{1} && InObjectData{1} < OutObjectData{1})
                        OutObjectData   = InObjectData;
                    end
                    
                    %t=0, n = 0, 0, 0
                    return
                else
                    [~, totalNoTriangle] = size(obj.trianglesList);
                    
                    for i= 1:totalNoTriangle
                        [InObjectData] = obj.trianglesList{i}.intersection(InRay);
                        
                        if ( InObjectData{1} && InObjectData{1} < OutObjectData{1})
                            OutObjectData   = InObjectData;
                        end
                    end
                    
                    
                    return
                end
            end
            
            OutObjectData{1} = 0;
            return
            
        end
        
        
        
    end
end