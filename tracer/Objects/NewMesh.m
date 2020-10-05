classdef NewMesh < handle
    
    properties
        position       = [0,0,0];
        colour         = [0,0,0];
        emission       = [0,0,0];
        materialType   = 0;
        kdNodeTree     = KDNode;
        
    end
    
    methods
        
%         function [obj] = set.kdNodeTree (obj, node)
%             obj.kdNodeTree = node;
%         end
        
        function [obj] = NewMesh(path_, emission_, color_,  materialType_,  position_, scale_)
            obj.position     = position_;
            obj.colour       = color_;
            obj.emission     = emission_;
            obj.materialType = materialType_;
            
%             fprintf('Building KDTree Node\n');
                        
            [InTrianglesList ] = loadTriangles( path_,position_,scale_ );
            obj.kdNodeTree     = buildKdtree( InTrianglesList, 0 );

            
        end
        
        function [ OutObjectData ] = intersection(obj,ray)
            % -- Go through the KdTree --
            [ OutObjectData ] = obj.kdNodeTree.intersection(ray);
            
        end
        
    end
    
end