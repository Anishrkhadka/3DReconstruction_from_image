classdef Mesh<handle
    
    properties
        mPosition      = [0,0,0];
        mColor         = [0,0,0];
        mEmission      = [0,0,0];
        mMaterialType  = 0;
        %         mTrianglesList = 0;
        mNode          = KDNode;
        
    end
    
    methods
        
        
        
        function [obj] = set.mNode (obj, node)
            obj.mNode = node;
        end
        
        function [obj] = Mesh(InMesh, emission_,color_,  materialType_,  position_, scale_)
            obj.mPosition     = position_;
            obj.mColor        = color_;
            obj.mEmission     = emission_;
            obj.mMaterialType = materialType_;
            
%             fprintf('Building KDTree Node\n');
%             [ InTrianglesList ] = loadObj( path_,position_,scale_ );
             [ InTrianglesList ] = InMesh ;
            
            obj.mNode          = buildKdtree( InTrianglesList, 0 );
    
       end
        
        
        
        function [ OutObjectData ] = intersection(obj,InRay)
            % -- Go through the KdTree --
            [OutObjectData] = obj.mNode.intersection(InRay);
            
        end
        
    end
    
end