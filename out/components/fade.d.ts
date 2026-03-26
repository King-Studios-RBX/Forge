import Vide, { Derivable } from "@rbxts/vide";
type FadeProps = {
    name?: string;
    groupColor?: Derivable<Color3>;
    groupTransparency?: Derivable<number>;
    visible?: Derivable<boolean>;
    anchor?: Derivable<Vector2>;
    position?: Derivable<UDim2>;
    size?: Derivable<UDim2>;
    rotation?: Derivable<number>;
    zIndex?: Derivable<number>;
    layoutOrder?: Derivable<number>;
    events?: Vide.InstanceEventAttributes<Frame>;
    before?: () => Vide.Node;
    children?: Vide.Node;
    parent?: Instance;
};
export default function FadeComponent(props: FadeProps): Vide.Node;
export {};
