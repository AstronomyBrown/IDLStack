/**
 * PolygonType.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package nvo_region;

public class PolygonType  extends nvo_region.ShapeType  implements java.io.Serializable {
    private nvo_region.VertexType[] vertex;

    public PolygonType() {
    }


    /**
     * Gets the vertex value for this PolygonType.
     * 
     * @return vertex
     */
    public nvo_region.VertexType[] getVertex() {
        return vertex;
    }


    /**
     * Sets the vertex value for this PolygonType.
     * 
     * @param vertex
     */
    public void setVertex(nvo_region.VertexType[] vertex) {
        this.vertex = vertex;
    }

    public nvo_region.VertexType getVertex(int i) {
        return this.vertex[i];
    }

    public void setVertex(int i, nvo_region.VertexType value) {
        this.vertex[i] = value;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof PolygonType)) return false;
        PolygonType other = (PolygonType) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = super.equals(obj) && 
            ((this.vertex==null && other.getVertex()==null) || 
             (this.vertex!=null &&
              java.util.Arrays.equals(this.vertex, other.getVertex())));
        __equalsCalc = null;
        return _equals;
    }

    private boolean __hashCodeCalc = false;
    public synchronized int hashCode() {
        if (__hashCodeCalc) {
            return 0;
        }
        __hashCodeCalc = true;
        int _hashCode = super.hashCode();
        if (getVertex() != null) {
            for (int i=0;
                 i<java.lang.reflect.Array.getLength(getVertex());
                 i++) {
                java.lang.Object obj = java.lang.reflect.Array.get(getVertex(), i);
                if (obj != null &&
                    !obj.getClass().isArray()) {
                    _hashCode += obj.hashCode();
                }
            }
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(PolygonType.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("urn:nvo-region", "polygonType"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("vertex");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:nvo-region", "Vertex"));
        elemField.setXmlType(new javax.xml.namespace.QName("urn:nvo-region", "vertexType"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
    }

    /**
     * Return type metadata object
     */
    public static org.apache.axis.description.TypeDesc getTypeDesc() {
        return typeDesc;
    }

    /**
     * Get Custom Serializer
     */
    public static org.apache.axis.encoding.Serializer getSerializer(
           java.lang.String mechType, 
           java.lang.Class _javaType,  
           javax.xml.namespace.QName _xmlType) {
        return 
          new  org.apache.axis.encoding.ser.BeanSerializer(
            _javaType, _xmlType, typeDesc);
    }

    /**
     * Get Custom Deserializer
     */
    public static org.apache.axis.encoding.Deserializer getDeserializer(
           java.lang.String mechType, 
           java.lang.Class _javaType,  
           javax.xml.namespace.QName _xmlType) {
        return 
          new  org.apache.axis.encoding.ser.BeanDeserializer(
            _javaType, _xmlType, typeDesc);
    }

}
