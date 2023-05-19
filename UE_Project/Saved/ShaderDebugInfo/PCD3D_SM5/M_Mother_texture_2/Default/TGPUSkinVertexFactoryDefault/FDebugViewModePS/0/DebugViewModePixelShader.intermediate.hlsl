#pragma warning(disable : 3571) // pow() intrinsic suggested to be used with abs()
cbuffer View
{
    row_major float4x4 View_View_SVPositionToTranslatedWorld : packoffset(c48);
    float View_View_MaterialTextureMipBias : packoffset(c144);
};

cbuffer DebugViewModePass
{
    float4 DebugViewModePass_DebugViewModePass_DebugViewMode_AccuracyColors[5] : packoffset(c7);
    float4 DebugViewModePass_DebugViewModePass_DebugViewMode_LODColors[8] : packoffset(c12);
};

cbuffer Material
{
    float4 Material_Material_PreshaderBuffer[2] : packoffset(c0);
};

float4 OneOverCPUTexCoordScales[64];
int4 TexCoordIndices[64];
float4 CPUTexelFactor;
float4 NormalizedComplexity;
int2 AnalysisParams;
float PrimitiveAlpha;
int TexCoordAnalysisIndex;
float CPULogDistance;
uint bShowQuadOverdraw;
uint bOutputQuadOverdraw;
int LODIndex;
float3 SkinCacheDebugColor;
int VisualizeMode;

RWTexture2D<uint> DebugViewModePass_QuadOverdraw;
Texture2D<float4> Material_Texture2D_0;
SamplerState Material_Texture2D_0Sampler;

static uint gl_PrimitiveID;
static float4 gl_FragCoord;
static float4 in_var_TEXCOORD1;
static float4 in_var_TEXCOORD2;
static float4 out_var_SV_Target0;

struct SPIRV_Cross_Input
{
    float4 in_var_TEXCOORD1 : TEXCOORD1;
    float4 in_var_TEXCOORD2 : TEXCOORD2;
    uint gl_PrimitiveID : SV_PrimitiveID;
    float4 gl_FragCoord : SV_Position;
};

struct SPIRV_Cross_Output
{
    float4 out_var_SV_Target0 : SV_Target0;
};

void frag_main()
{
    float4 _863 = 0.0f.xxxx;
    [branch]
    if ((((VisualizeMode == 1) || (VisualizeMode == 2)) || (VisualizeMode == 3)) || (VisualizeMode == 4))
    {
        float3 _858 = 0.0f.xxx;
        if (bOutputQuadOverdraw != 0u)
        {
            float3 _857 = 0.0f.xxx;
            [branch]
            if ((bShowQuadOverdraw != 0u) && (NormalizedComplexity.x > 0.0f))
            {
                uint2 _784 = uint2(gl_FragCoord.xy) / uint2(2u, 2u);
                uint _786 = 0u;
                int _789 = 0;
                _786 = 3u;
                _789 = 0;
                uint _787 = 0u;
                int _790 = 0;
                [loop]
                for (int _791 = 0; _791 < 24; _786 = _787, _789 = _790, _791++)
                {
                    uint _812 = 0u;
                    int _813 = 0;
                    [branch]
                    if (true && (_789 == 1))
                    {
                        uint4 _801 = DebugViewModePass_QuadOverdraw[_784].xxxx;
                        uint _802 = _801.x;
                        bool _805 = ((_802 >> 2u) - 1u) != uint(gl_PrimitiveID);
                        uint _810 = 0u;
                        [flatten]
                        if (_805)
                        {
                            _810 = _786;
                        }
                        else
                        {
                            _810 = _802 & 3u;
                        }
                        _812 = _810;
                        _813 = _805 ? (-1) : _789;
                    }
                    else
                    {
                        _812 = _786;
                        _813 = _789;
                    }
                    int _828 = 0;
                    [branch]
                    if (_813 == 2)
                    {
                        uint4 _818 = DebugViewModePass_QuadOverdraw[_784].xxxx;
                        uint _820 = _818.x & 3u;
                        bool _821 = _820 == _812;
                        [branch]
                        if (_821)
                        {
                            DebugViewModePass_QuadOverdraw[_784] = 0u;
                        }
                        else
                        {
                        }
                        _787 = _821 ? _812 : _820;
                        _828 = _821 ? (-1) : _813;
                    }
                    else
                    {
                        _787 = _812;
                        _828 = _813;
                    }
                    [branch]
                    if (_828 == 0)
                    {
                        uint _835;
                        InterlockedCompareExchange(DebugViewModePass_QuadOverdraw[_784], 0u, (uint(gl_PrimitiveID) + 1u) << 2u, _835);
                        bool _840 = ((_835 >> 2u) - 1u) == uint(gl_PrimitiveID);
                        [branch]
                        if (_840)
                        {
                            uint _843;
                            InterlockedAdd(DebugViewModePass_QuadOverdraw[_784], 1u, _843);
                        }
                        _790 = _840 ? 1 : ((_835 == 0u) ? 2 : _828);
                    }
                    else
                    {
                        _790 = _828;
                    }
                }
                [branch]
                if (_789 == 2)
                {
                    DebugViewModePass_QuadOverdraw[_784] = 0u;
                }
                float3 _856 = NormalizedComplexity.xyz;
                _856.x = NormalizedComplexity.x * (4.0f / float((_789 != (-2)) ? (1u + _786) : 0u));
                _857 = _856;
            }
            else
            {
                _857 = NormalizedComplexity.xyz;
            }
            _858 = _857;
        }
        else
        {
            _858 = NormalizedComplexity.xyz;
        }
        _863 = float4(_858, 1.0f);
    }
    else
    {
        float4 _760 = 0.0f.xxxx;
        if (VisualizeMode == 5)
        {
            float3 _753 = 0.0f.xxx;
            if (CPULogDistance >= 0.0f)
            {
                float4 _730 = mul(float4(gl_FragCoord.xyz, 1.0f), View_View_SVPositionToTranslatedWorld);
                float _739 = clamp(log2(max(1.0f, length(_730.xyz / _730.w.xxx))) - CPULogDistance, -1.9900000095367431640625f, 1.9900000095367431640625f);
                int _742 = int(floor(_739) + 2.0f);
                _753 = lerp(DebugViewModePass_DebugViewModePass_DebugViewMode_AccuracyColors[_742].xyz, DebugViewModePass_DebugViewModePass_DebugViewMode_AccuracyColors[_742 + 1].xyz, frac(_739).xxx);
            }
            else
            {
                _753 = 0.014999999664723873138427734375f.xxx;
            }
            _760 = float4(_753, PrimitiveAlpha);
        }
        else
        {
            float4 _720 = 0.0f.xxxx;
            if (VisualizeMode == 6)
            {
                float3 _713 = 0.0f.xxx;
                if (TexCoordAnalysisIndex >= 0)
                {
                    bool _633 = false;
                    float _650 = 0.0f;
                    do
                    {
                        _633 = TexCoordAnalysisIndex == 0;
                        [flatten]
                        if (_633)
                        {
                            _650 = CPUTexelFactor.x;
                            break;
                        }
                        [flatten]
                        if (TexCoordAnalysisIndex == 1)
                        {
                            _650 = CPUTexelFactor.y;
                            break;
                        }
                        [flatten]
                        if (TexCoordAnalysisIndex == 2)
                        {
                            _650 = CPUTexelFactor.z;
                            break;
                        }
                        _650 = CPUTexelFactor.w;
                        break;
                    } while(false);
                    float3 _712 = 0.0f.xxx;
                    if (_650 > 0.0f)
                    {
                        float4 _658 = mul(float4(gl_FragCoord.xyz, 1.0f), View_View_SVPositionToTranslatedWorld);
                        float3 _662 = _658.xyz / _658.w.xxx;
                        float2 _677 = 0.0f.xx;
                        do
                        {
                            [flatten]
                            if (_633)
                            {
                                _677 = in_var_TEXCOORD1.xy;
                                break;
                            }
                            [flatten]
                            if (TexCoordAnalysisIndex == 1)
                            {
                                _677 = in_var_TEXCOORD1.zw;
                                break;
                            }
                            [flatten]
                            if (TexCoordAnalysisIndex == 2)
                            {
                                _677 = in_var_TEXCOORD2.xy;
                                break;
                            }
                            _677 = in_var_TEXCOORD2.zw;
                            break;
                        } while(false);
                        float2 _678 = ddx_fine(_677);
                        float2 _679 = ddy_fine(_677);
                        float _698 = clamp(log2(_650) - log2(sqrt(length(cross(ddx_fine(_662), ddy_fine(_662))) / max(abs((_678.x * _679.y) - (_678.y * _679.x)), 1.0000000133514319600180897396058e-10f))), -1.9900000095367431640625f, 1.9900000095367431640625f);
                        int _701 = int(floor(_698) + 2.0f);
                        _712 = lerp(DebugViewModePass_DebugViewModePass_DebugViewMode_AccuracyColors[_701].xyz, DebugViewModePass_DebugViewModePass_DebugViewMode_AccuracyColors[_701 + 1].xyz, frac(_698).xxx);
                    }
                    else
                    {
                        _712 = 0.014999999664723873138427734375f.xxx;
                    }
                    _713 = _712;
                }
                else
                {
                    float _483 = 0.0f;
                    float _484 = 0.0f;
                    if (CPUTexelFactor.x > 0.0f)
                    {
                        float4 _454 = mul(float4(gl_FragCoord.xyz, 1.0f), View_View_SVPositionToTranslatedWorld);
                        float3 _458 = _454.xyz / _454.w.xxx;
                        float2 _460 = ddx_fine(in_var_TEXCOORD1.xy);
                        float2 _461 = ddy_fine(in_var_TEXCOORD1.xy);
                        float _480 = clamp(log2(CPUTexelFactor.x) - log2(sqrt(length(cross(ddx_fine(_458), ddy_fine(_458))) / max(abs((_460.x * _461.y) - (_460.y * _461.x)), 1.0000000133514319600180897396058e-10f))), -1.9900000095367431640625f, 1.9900000095367431640625f);
                        _483 = max(_480, -1024.0f);
                        _484 = min(_480, 1024.0f);
                    }
                    else
                    {
                        _483 = -1024.0f;
                        _484 = 1024.0f;
                    }
                    float _523 = 0.0f;
                    float _524 = 0.0f;
                    if (CPUTexelFactor.y > 0.0f)
                    {
                        float4 _494 = mul(float4(gl_FragCoord.xyz, 1.0f), View_View_SVPositionToTranslatedWorld);
                        float3 _498 = _494.xyz / _494.w.xxx;
                        float2 _500 = ddx_fine(in_var_TEXCOORD1.zw);
                        float2 _501 = ddy_fine(in_var_TEXCOORD1.zw);
                        float _520 = clamp(log2(CPUTexelFactor.y) - log2(sqrt(length(cross(ddx_fine(_498), ddy_fine(_498))) / max(abs((_500.x * _501.y) - (_500.y * _501.x)), 1.0000000133514319600180897396058e-10f))), -1.9900000095367431640625f, 1.9900000095367431640625f);
                        _523 = max(_520, _483);
                        _524 = min(_520, _484);
                    }
                    else
                    {
                        _523 = _483;
                        _524 = _484;
                    }
                    float _563 = 0.0f;
                    float _564 = 0.0f;
                    if (CPUTexelFactor.z > 0.0f)
                    {
                        float4 _534 = mul(float4(gl_FragCoord.xyz, 1.0f), View_View_SVPositionToTranslatedWorld);
                        float3 _538 = _534.xyz / _534.w.xxx;
                        float2 _540 = ddx_fine(in_var_TEXCOORD2.xy);
                        float2 _541 = ddy_fine(in_var_TEXCOORD2.xy);
                        float _560 = clamp(log2(CPUTexelFactor.z) - log2(sqrt(length(cross(ddx_fine(_538), ddy_fine(_538))) / max(abs((_540.x * _541.y) - (_540.y * _541.x)), 1.0000000133514319600180897396058e-10f))), -1.9900000095367431640625f, 1.9900000095367431640625f);
                        _563 = max(_560, _523);
                        _564 = min(_560, _524);
                    }
                    else
                    {
                        _563 = _523;
                        _564 = _524;
                    }
                    float _603 = 0.0f;
                    float _604 = 0.0f;
                    if (CPUTexelFactor.w > 0.0f)
                    {
                        float4 _574 = mul(float4(gl_FragCoord.xyz, 1.0f), View_View_SVPositionToTranslatedWorld);
                        float3 _578 = _574.xyz / _574.w.xxx;
                        float2 _580 = ddx_fine(in_var_TEXCOORD2.zw);
                        float2 _581 = ddy_fine(in_var_TEXCOORD2.zw);
                        float _600 = clamp(log2(CPUTexelFactor.w) - log2(sqrt(length(cross(ddx_fine(_578), ddy_fine(_578))) / max(abs((_580.x * _581.y) - (_580.y * _581.x)), 1.0000000133514319600180897396058e-10f))), -1.9900000095367431640625f, 1.9900000095367431640625f);
                        _603 = max(_600, _563);
                        _604 = min(_600, _564);
                    }
                    else
                    {
                        _603 = _563;
                        _604 = _564;
                    }
                    int2 _606 = int2(gl_FragCoord.xy);
                    float _612 = ((_606.x & 8) == (_606.y & 8)) ? _604 : _603;
                    float3 _630 = 0.0f.xxx;
                    if (abs(_612) != 1024.0f)
                    {
                        int _619 = int(floor(_612) + 2.0f);
                        _630 = lerp(DebugViewModePass_DebugViewModePass_DebugViewMode_AccuracyColors[_619].xyz, DebugViewModePass_DebugViewModePass_DebugViewMode_AccuracyColors[_619 + 1].xyz, frac(_612).xxx);
                    }
                    else
                    {
                        _630 = 0.014999999664723873138427734375f.xxx;
                    }
                    _713 = _630;
                }
                _720 = float4(_713, PrimitiveAlpha);
            }
            else
            {
                float4 _438 = 0.0f.xxxx;
                if ((VisualizeMode == 7) || (VisualizeMode == 8))
                {
                    int2 _283 = int2(gl_FragCoord.xy);
                    float2 _285 = ddx(in_var_TEXCOORD1.xy);
                    float2 _288 = ddx(in_var_TEXCOORD1.zw);
                    float2 _291 = ddx(in_var_TEXCOORD2.xy);
                    float2 _294 = ddx(in_var_TEXCOORD2.zw);
                    float4 _297 = 1.0f.xxxx / float4(length(_285), length(_288), length(_291), length(_294));
                    float2 _298 = ddy(in_var_TEXCOORD1.xy);
                    float2 _300 = ddy(in_var_TEXCOORD1.zw);
                    float2 _302 = ddy(in_var_TEXCOORD2.xy);
                    float2 _304 = ddy(in_var_TEXCOORD2.zw);
                    float4 _307 = 1.0f.xxxx / float4(length(_298), length(_300), length(_302), length(_304));
                    bool _310 = AnalysisParams.y != 0;
                    float2 _319 = 0.0f.xx;
                    [flatten]
                    if (_310)
                    {
                        int _314 = _283.y / 32;
                        bool2 _317 = (0 != (_314 - 4 * (_314 / 4))).xx;
                        _319 = float2(_317.x ? 0.0f.xx.x : in_var_TEXCOORD1.xy.x, _317.y ? 0.0f.xx.y : in_var_TEXCOORD1.xy.y);
                    }
                    else
                    {
                        _319 = in_var_TEXCOORD1.xy;
                    }
                    bool _330 = false;
                    float2 _320 = ddx(_319);
                    float2 _322 = ddy(_319);
                    float _343 = 0.0f;
                    do
                    {
                        _330 = TexCoordIndices[0].x == 0;
                        [flatten]
                        if (_330)
                        {
                            _343 = _297.x;
                            break;
                        }
                        [flatten]
                        if (TexCoordIndices[0].x == 1)
                        {
                            _343 = _297.y;
                            break;
                        }
                        [flatten]
                        if (TexCoordIndices[0].x == 2)
                        {
                            _343 = _297.z;
                            break;
                        }
                        _343 = _297.w;
                        break;
                    } while(false);
                    float _359 = 0.0f;
                    do
                    {
                        [flatten]
                        if (_330)
                        {
                            _359 = _307.x;
                            break;
                        }
                        [flatten]
                        if (TexCoordIndices[0].x == 1)
                        {
                            _359 = _307.y;
                            break;
                        }
                        [flatten]
                        if (TexCoordIndices[0].x == 2)
                        {
                            _359 = _307.z;
                            break;
                        }
                        _359 = _307.w;
                        break;
                    } while(false);
                    float _361 = min(length(_320) * _343, length(_322) * _359);
                    bool _365 = AnalysisParams.x == (-1);
                    bool _366 = AnalysisParams.x == 0;
                    bool _368 = (OneOverCPUTexCoordScales[0].x > 0.0f) && (_365 || _366);
                    float _369 = _361 * OneOverCPUTexCoordScales[0].x;
                    float _371 = _368 ? min(256.0f, _369) : 256.0f;
                    int _374 = _283.x;
                    float4 _380 = 256.0f.xxxx;
                    _380.x = (_310 && ((_374 / 32) == 0)) ? min(256.0f, _361) : 256.0f;
                    float4 _386 = Material_Texture2D_0.SampleBias(Material_Texture2D_0Sampler, _319, View_View_MaterialTextureMipBias);
                    float _394 = 0.0f;
                    if (_366)
                    {
                        _394 = _366 ? lerp(0.4000000059604644775390625f, 1.0f, clamp(dot(_386.xyz, float3(0.300000011920928955078125f, 0.589999973773956298828125f, 0.10999999940395355224609375f)), 0.0f, 1.0f)) : 1.0f;
                    }
                    else
                    {
                        _394 = 1.0f;
                    }
                    float _397 = clamp(dot(_386.xyz, float3(0.300000011920928955078125f, 0.589999973773956298828125f, 0.10999999940395355224609375f)), 0.0f, 1.0f);
                    float4 _437 = 0.0f.xxxx;
                    if (_310)
                    {
                        _437 = _380;
                    }
                    else
                    {
                        float3 _430 = 0.0f.xxx;
                        if (_371 != 256.0f)
                        {
                            float _415 = clamp(log2((((_374 & 8) == (_283.y & 8)) || (AnalysisParams.x != (-1))) ? _371 : (_368 ? max(0.0f, _369) : 0.0f)), -1.9900000095367431640625f, 1.9900000095367431640625f);
                            int _418 = int(floor(_415) + 2.0f);
                            _430 = lerp(DebugViewModePass_DebugViewModePass_DebugViewMode_AccuracyColors[_418].xyz, DebugViewModePass_DebugViewModePass_DebugViewMode_AccuracyColors[_418 + 1].xyz, frac(_415).xxx) * (_365 ? lerp(0.4000000059604644775390625f, 1.0f, _397) : _394);
                        }
                        else
                        {
                            _430 = 0.014999999664723873138427734375f.xxx * _397;
                        }
                        _437 = float4(_430, PrimitiveAlpha);
                    }
                    _438 = _437;
                }
                else
                {
                    bool _144 = VisualizeMode == 9;
                    float4 _281 = 0.0f.xxxx;
                    if (_144 || (VisualizeMode == 10))
                    {
                        float2 _215 = ddx_fine(in_var_TEXCOORD1.xy);
                        float2 _216 = ddy_fine(in_var_TEXCOORD1.xy);
                        bool _219 = AnalysisParams.x == 0;
                        float _228 = 0.0f;
                        if (_219)
                        {
                            _228 = max(0.0f, 1.0f / max(min(length(_215), length(_216)), 1.0000000133514319600180897396058e-10f));
                        }
                        else
                        {
                            _228 = 0.0f;
                        }
                        float4 _234 = Material_Texture2D_0.SampleBias(Material_Texture2D_0Sampler, in_var_TEXCOORD1.xy, View_View_MaterialTextureMipBias);
                        float _242 = 0.0f;
                        if (_219)
                        {
                            _242 = _219 ? lerp(0.4000000059604644775390625f, 1.0f, clamp(dot(_234.xyz, float3(0.300000011920928955078125f, 0.589999973773956298828125f, 0.10999999940395355224609375f)), 0.0f, 1.0f)) : 0.0f;
                        }
                        else
                        {
                            _242 = 0.0f;
                        }
                        float3 _246 = 0.014999999664723873138427734375f.xxx * clamp(dot(_234.xyz, float3(0.300000011920928955078125f, 0.589999973773956298828125f, 0.10999999940395355224609375f)), 0.0f, 1.0f);
                        float3 _274 = 0.0f.xxx;
                        if (_144)
                        {
                            float3 _273 = 0.0f.xxx;
                            if (_228 > 0.0f)
                            {
                                float _258 = clamp(log2(float(AnalysisParams.y) / _228), -1.9900000095367431640625f, 1.9900000095367431640625f);
                                int _261 = int(floor(_258) + 2.0f);
                                _273 = lerp(DebugViewModePass_DebugViewModePass_DebugViewMode_AccuracyColors[_261].xyz, DebugViewModePass_DebugViewModePass_DebugViewMode_AccuracyColors[_261 + 1].xyz, frac(_258).xxx) * _242;
                            }
                            else
                            {
                                _273 = _246;
                            }
                            _274 = _273;
                        }
                        else
                        {
                            _274 = _246;
                        }
                        _281 = float4(_274, PrimitiveAlpha);
                    }
                    else
                    {
                        float4 _213 = 0.0f.xxxx;
                        if (VisualizeMode == 12)
                        {
                            _213 = float4(DebugViewModePass_DebugViewModePass_DebugViewMode_LODColors[LODIndex].xyz * (0.0500000007450580596923828125f + (0.949999988079071044921875f * dot(Material_Texture2D_0.SampleBias(Material_Texture2D_0Sampler, in_var_TEXCOORD1.xy, View_View_MaterialTextureMipBias).xyz + lerp(0.0f.xxx, Material_Material_PreshaderBuffer[1].yzw, Material_Material_PreshaderBuffer[1].x.xxx), float3(0.300000011920928955078125f, 0.589999973773956298828125f, 0.10999999940395355224609375f)))), 1.0f);
                        }
                        else
                        {
                            float4 _183 = 0.0f.xxxx;
                            if (VisualizeMode == 13)
                            {
                                _183 = float4(SkinCacheDebugColor * (0.0500000007450580596923828125f + (0.949999988079071044921875f * dot(Material_Texture2D_0.SampleBias(Material_Texture2D_0Sampler, in_var_TEXCOORD1.xy, View_View_MaterialTextureMipBias).xyz + lerp(0.0f.xxx, Material_Material_PreshaderBuffer[1].yzw, Material_Material_PreshaderBuffer[1].x.xxx), float3(0.300000011920928955078125f, 0.589999973773956298828125f, 0.10999999940395355224609375f)))), 1.0f);
                            }
                            else
                            {
                                _183 = float4(1.0f, 0.0f, 1.0f, 1.0f);
                            }
                            _213 = _183;
                        }
                        _281 = _213;
                    }
                    _438 = _281;
                }
                _720 = _438;
            }
            _760 = _720;
        }
        _863 = _760;
    }
    out_var_SV_Target0 = _863;
}

[earlydepthstencil]
SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input)
{
    gl_PrimitiveID = stage_input.gl_PrimitiveID;
    gl_FragCoord = stage_input.gl_FragCoord;
    gl_FragCoord.w = 1.0 / gl_FragCoord.w;
    in_var_TEXCOORD1 = stage_input.in_var_TEXCOORD1;
    in_var_TEXCOORD2 = stage_input.in_var_TEXCOORD2;
    frag_main();
    SPIRV_Cross_Output stage_output;
    stage_output.out_var_SV_Target0 = out_var_SV_Target0;
    return stage_output;
}
