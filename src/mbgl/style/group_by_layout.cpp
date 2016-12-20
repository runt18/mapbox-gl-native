#include <mbgl/style/group_by_layout.hpp>
#include <mbgl/style/layer.hpp>
#include <mbgl/style/layer_impl.hpp>

#include <map>

namespace mbgl {
namespace style {

class LessLayout {
public:
    bool operator()(const Layer* lhs, const Layer* rhs) const {
        if (lhs->type != rhs->type)
            return lhs->type < rhs->type;
        if (lhs->baseImpl->source != rhs->baseImpl->source)
            return lhs->baseImpl->source < rhs->baseImpl->source;
        if (lhs->baseImpl->sourceLayer != rhs->baseImpl->sourceLayer)
            return lhs->baseImpl->sourceLayer < rhs->baseImpl->sourceLayer;
        if (lhs->baseImpl->minZoom != rhs->baseImpl->minZoom)
            return lhs->baseImpl->minZoom < rhs->baseImpl->minZoom;
        if (lhs->baseImpl->maxZoom != rhs->baseImpl->maxZoom)
            return lhs->baseImpl->maxZoom < rhs->baseImpl->maxZoom;
        if (lhs->baseImpl->filter != rhs->baseImpl->filter)
            return lhs->baseImpl->filter < rhs->baseImpl->filter;
        return lhs->baseImpl->lessLayout(*rhs->baseImpl);
    }
};

std::vector<std::vector<std::unique_ptr<Layer>>> groupByLayout(std::vector<std::unique_ptr<Layer>> layers) {
    std::vector<std::vector<std::unique_ptr<Layer>>> result;

    if (layers.empty()) {
        return result;
    }

    std::map<Layer*, std::vector<std::unique_ptr<Layer>>, LessLayout> map;

    for (auto& layer : layers) {
        auto& vector = map[layer.get()];
        vector.push_back(std::move(layer));
    }

    for (auto& pair : map) {
        result.push_back(std::move(pair.second));
    }

    return result;
}

} // namespace style
} // namespace mbgl
